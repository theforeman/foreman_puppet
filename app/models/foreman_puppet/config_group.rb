module ForemanPuppet
  class ConfigGroup < ApplicationRecord
    self.table_name = 'config_groups'

    audited
    include Authorizable
    include Parameterizable::ByIdName

    validates_lengths_from_database

    has_many :config_group_classes, dependent: :destroy
    has_many :puppetclasses, through: :config_group_classes
    has_many :host_config_groups, dependent: :destroy
    has_many_hosts through: :host_config_groups, source: :host, source_type: 'Host::Managed'
    has_many :hostgroups, through: :host_config_groups, source: :host, source_type: 'Hostgroup'

    validates :name, presence: true, uniqueness: true

    scoped_search on: :name, complete_value: true
    scoped_search relation: :puppetclasses, on: :name, complete_value: true, rename: :puppetclass, only_explicit: true, operators: ['= ', '~ ']

    default_scope -> { order('config_groups.name') }

    # the following methods are required for app/views/puppetclasses/_class_selection.html.erb
    alias_method :classes, :puppetclasses
    alias_method :individual_puppetclasses, :puppetclasses

    def available_puppetclasses
      Puppetclass.where(nil)
    end

    # for auditing
    def to_label
      name
    end

    def hosts_count
      ::Host::Managed.authorized.search_for(%(config_group="#{name}")).size
    end

    def hostgroups_count
      ::Hostgroup.authorized.search_for(%(config_group="#{name}")).size
    end
  end
end
