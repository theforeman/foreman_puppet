module ForemanPuppet
  class HostPuppetFacet < ApplicationRecord
    self.table_name = 'host_puppet_facets'
    audited associated_with: :host

    include Facets::Base
    include ForemanPuppet::PuppetFacetCommon

    has_one :puppetca_token, :foreign_key => :host_id, :dependent => :destroy, :inverse_of => :host, :class_name => 'ForemanPuppet::Token::Puppetca'
    has_many :host_classes, dependent: :destroy, class_name: 'ForemanPuppet::HostClass'
    has_many :puppetclasses, through: :host_classes

    validates :environment_id, presence: true, unless: ->(facet) { facet.puppet_proxy_id.blank? }

    after_validation :ensure_puppet_associations
    before_save :clear_puppetinfo, if: :environment_id_changed?

    def self.populate_fields_from_facts(host, parser, type, source_proxy)
      type ||= 'puppet'
      return unless type == 'puppet'

      facet = host.puppet || host.build_puppet
      if Setting[:update_environment_from_facts]
        facet.environment = parser.environment if parser.environment.present?
      elsif parser.environment.present?
        facet.environment ||= parser.environment
      end

      # if proxy authentication is enabled and we have no puppet proxy set and the upload came from puppet,
      # use it as puppet proxy.
      facet.puppet_proxy ||= source_proxy
    end

    def self.inherited_attributes(new_hostgroup, attributes)
      { 'environment_id' => new_hostgroup.puppet&.inherited_environment_id,
        'puppet_proxy_id' => new_hostgroup.puppet&.inherited_puppet_proxy_id,
        'puppet_ca_proxy_id' => new_hostgroup.puppet&.inherited_puppet_ca_proxy_id }.merge(attributes)
    end

    def clear_puppetinfo
      return if environment
      self.puppetclasses = []
      self.config_groups = []
    end

    # the environment used by #clases nees to be self.environment and not self.parent.environment
    def parent_classes
      return [] unless host.hostgroup
      host.hostgroup.puppet&.classes(environment)
    end

    def parent_config_groups
      return [] unless host.hostgroup
      host.hostgroup.puppet&.all_config_groups
    end

    def ensure_puppet_associations
      status = validate_association_taxonomy(:environment)
      return status unless environment

      puppetclasses.where.not(id: environment.puppetclasses.reorder(nil)).find_each do |puppetclass|
        errors.add(
          :puppetclasses,
          format(_('%{puppetclass} does not belong to the %{environment} environment'), puppetclass: puppetclass, environment: environment)
        )
        status = false
      end
      status
    end

    # this method accepts a puppets external node yaml output and generate a node in our setup
    # it is assumed that you already have the node (e.g. imported by one of the rack tasks)
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def import_puppet_node(nodeinfo)
      myklasses = []
      # puppet classes
      classes = nodeinfo['classes']
      classes = classes.keys if classes.is_a?(Hash)
      classes.each do |klass|
        if (pc = ForemanPuppet::Puppetclass.find_by(name: klass.to_s))
          myklasses << pc
        else
          error = format(_("Failed to import %{klass} for %{name}: doesn't exists in our database - ignoring"), klass: klass, name: name)
          logger.warn error
          $stdout.puts error
        end
        self.puppetclasses = myklasses
      end

      # parameters are a bit more tricky, as some classifiers provide the facts as parameters as well
      # not sure what is puppet priority about it, but we ignore it if has a fact with the same name.
      # additionally, we don't import any non strings values, as puppet don't know what to do with those as well.

      myparams = host.info['parameters']
      nodeinfo['parameters'].each_pair do |param, value|
        next if host.fact_names.exists? name: param
        next unless value.is_a?(String)

        # we already have this parameter
        next if myparams.key?(param) && myparams[param] == value

        unless (hp = host.host_parameters.create(name: param, value: value))
          logger.warn "Failed to import #{param}/#{value} for #{name}: #{hp.errors.full_messages.join(', ')}"
          $stdout.puts $ERROR_INFO
        end
      end

      host.clear_host_parameters_cache!
      save
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    private

    # Copy of method with same name, but for facet associations
    def validate_association_taxonomy(association_name)
      association = self.class.reflect_on_association(association_name)
      raise ArgumentError, "Association #{association_name} not found" unless association
      associated_object_id = public_send(association.foreign_key)
      if associated_object_id.present? &&
         association.klass.with_taxonomy_scope(host.organization, host.location).find_by(id: associated_object_id).blank?
        errors.add(
          association.foreign_key,
          format(_("with id %{object_id} doesn't exist or is not assigned to proper organization and/or location"), object_id: associated_object_id)
        )
        false
      else
        true
      end
    end
  end
end
