module ForemanPuppet
  class Puppetclass < ApplicationRecord
    self.table_name = 'puppetclasses'

    graphql_type 'ForemanPuppet::Types::Puppetclass'

    audited
    include Authorizable
    include ScopedSearchExtensions
    extend FriendlyId
    friendly_id :name
    include Parameterizable::ByIdName

    validates_lengths_from_database
    before_destroy EnsureNotUsedBy.new(:hosts, :hostgroups)
    has_many :environment_classes, dependent: :destroy, inverse_of: :puppetclass
    has_many :environments, -> { distinct }, through: :environment_classes
    has_many :organizations, -> { distinct.reorder(nil) }, through: :environments
    has_many :locations, -> { distinct.reorder(nil) }, through: :environments

    # rubocop:disable Rails/HasAndBelongsToMany
    has_and_belongs_to_many :operatingsystems
    # rubocop:enable Rails/HasAndBelongsToMany
    has_many :hostgroup_classes, dependent: :destroy
    has_many :hostgroup_puppet_facets, through: :hostgroup_classes
    has_many :hostgroups, through: :hostgroup_puppet_facets
    has_many :host_classes, dependent: :destroy
    has_many :host_puppet_facets, through: :host_classes
    has_many_hosts through: :host_puppet_facets
    has_many :config_group_classes, dependent: :destroy
    has_many :config_groups, through: :config_group_classes

    has_many :class_params, -> { distinct }, through: :environment_classes, source: :puppetclass_lookup_key
    accepts_nested_attributes_for :environment_classes
    accepts_nested_attributes_for :class_params, reject_if: ->(a) { a[:key].blank? }, allow_destroy: true

    validates :name, uniqueness: true, presence: true, no_whitespace: true

    alias_attribute :smart_class_parameters, :class_params
    alias_attribute :smart_class_parameter_ids, :class_param_ids

    default_scope -> { order(:name) }

    scoped_search on: :name, complete_value: true
    scoped_search relation: :environments, on: :name, complete_value: true, rename: 'environment'
    scoped_search relation: :organizations, on: :name, complete_value: true, rename: 'organization', only_explicit: true
    scoped_search relation: :locations, on: :name, complete_value: true, rename: 'location', only_explicit: true
    scoped_search relation: :hostgroups, on: :name, complete_value: true, rename: 'hostgroup', only_explicit: true
    scoped_search relation: :config_groups, on: :name, complete_value: true, rename: 'config_group', only_explicit: true
    scoped_search relation: :hosts, on: :name, complete_value: true, rename: 'host', ext_method: :search_by_host, only_explicit: true
    scoped_search relation: :class_params, on: :key, complete_value: true, only_explicit: true

    scope :not_in_any_environment, -> { left_outer_joins(:environment_classes).where(environment_classes: { environment_id: nil }) }

    # returns a hash containing modules and associated classes
    def self.classes2hash(classes)
      hash = {}
      classes.each do |klass|
        next unless (mod = klass.module_name)
        hash[mod] ||= []
        hash[mod] << klass
      end
      hash
    end

    # For API v2 - eliminate node :puppetclass for each object. returns a hash containing modules and associated classes
    def self.classes2hash_v2(classes)
      hash = {}
      classes.each do |klass|
        if (mod = klass.module_name)
          hash[mod] ||= []
          hash[mod] << { id: klass.id, name: klass.name, created_at: klass.created_at, updated_at: klass.updated_at }
        end
      end
      hash
    end

    # For Audits to be correctly taxed for Puppetclass creation
    # Puppetclass gets saved before the environment class and thus taxonomy ids are empty
    # We collect the ids from unsaved environment_classes for the Audits correct taxation
    def location_ids
      environment_classes.select(&:new_record?).flat_map { |ec| ec.environment.location_ids }.concat(super).uniq
    end

    def organization_ids
      environment_classes.select(&:new_record?).flat_map { |ec| ec.environment.organization_ids }.concat(super).uniq
    end

    # returns module name (excluding of the class name)
    # if class separator does not exists (the "::" chars), then returns the whole class name
    def module_name
      (i = name.index('::')) ? name[0..i - 1] : name
    end

    # returns class name (excluding of the module name)
    def klass
      name.gsub("#{module_name}::", '')
    end

    def all_hostgroups(with_descendants: true, unsorted: false)
      hgs = Hostgroup.authorized
                     .left_outer_joins(puppet: [:hostgroup_classes, { config_groups: [:config_group_classes] }])
                     .where("#{id} IN (hostgroup_classes.puppetclass_id, config_group_classes.puppetclass_id)")
                     .distinct
      hgs = hgs.reorder('') if unsorted
      hgs = hgs.flat_map(&:subtree).uniq if with_descendants
      hgs
    end

    def hosts_count
      hostgroup_ids = all_hostgroups(unsorted: true).map(&:id)
      Host::Managed.authorized
                   .reorder(nil)
                   .left_outer_joins(puppet: [:host_classes, { config_groups: [:config_group_classes] }])
                   .where('(? IN (host_classes.puppetclass_id, config_group_classes.puppetclass_id)) OR (hosts.hostgroup_id IN (?))', id, hostgroup_ids)
                   .distinct
                   .count
    end

    # We are going through two associations, so we are on our own to define modifiers
    def hostgroup_ids=(hg_ids)
      hg_ids = Array(hg_ids).reject(&:blank?)
      hg_to_facets_ids = HostgroupPuppetFacet.where(hostgroup_id: hg_ids).pluck(:hostgroup_id, :id).to_h
      missing_facet_ids = hg_ids.map(&:to_i) - hg_to_facets_ids.keys
      new_facet_ids = missing_facet_ids.map { |hg_id| HostgroupPuppetFacet.create(hostgroup_id: hg_id).id }
      self.hostgroup_puppet_facet_ids = hg_to_facets_ids.values + new_facet_ids
    end

    def self.search_by_host(_key, operator, value)
      conditions = sanitize_sql_for_conditions(["hosts.name #{operator} ?", value_to_sql(operator, value)])
      direct     = Puppetclass.joins(host_puppet_facets: :host).where(conditions).pluck(:id).uniq
      hostgroup  = Hostgroup.joins(:hosts).find_by(conditions)
      indirect   = if hostgroup.blank?
                     []
                   else
                     HostgroupClass.joins(hostgroup_puppet_facet: :hostgroup)
                                   .where(Hostgroup.arel_table[:id].in(hostgroup.path_ids))
                                   .pluck(:puppetclass_id).uniq
                   end
      return { conditions: '1=0' } if direct.blank? && indirect.blank?

      puppet_classes = (direct + indirect).uniq
      { conditions: "puppetclasses.id IN(#{puppet_classes.join(',')})" }
    end
  end
end
