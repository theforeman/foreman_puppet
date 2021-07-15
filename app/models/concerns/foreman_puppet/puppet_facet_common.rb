module ForemanPuppet
  # Common methods between host and hostgroup
  # mostly for template rendering consistency
  module PuppetFacetCommon
    extend ActiveSupport::Concern

    include ::BelongsToProxies

    included do
      belongs_to :environment
      has_many :host_config_groups, as: :host, dependent: :destroy
      has_many :config_groups, through: :host_config_groups
      has_many :config_group_classes, through: :config_groups
      has_many :group_puppetclasses, through: :config_groups, source: :puppetclasses

      belongs_to_proxy :puppet_proxy,
        feature: N_('Puppet'),
        label: N_('Puppet Proxy'),
        description: N_('Use the Puppetserver configured on this Smart Proxy'),
        api_description: N_('Puppet proxy ID')

      belongs_to_proxy :puppet_ca_proxy,
        feature: 'Puppet CA',
        label: N_('Puppet CA Proxy'),
        description: N_('Use the Puppetserver CA configured on this Smart Proxy'),
        api_description: N_('Puppet CA proxy ID')

      alias_method :all_puppetclasses, :classes

      before_save :check_puppet_ca_proxy_is_required?
    end

    def parent_name
      if is_a?(ForemanPuppet::HostPuppetFacet)
        host.hostgroup&.name
      elsif is_a?(ForemanPuppet::HostgroupPuppetFacet)
        hostgroup.parent&.name
      end
    end

    def cg_class_ids
      cg_ids = if is_a?(ForemanPuppet::HostgroupPuppetFacet)
                 hostgroup.path.each.map { |hg| hg.puppet&.config_group_ids }.compact.flatten.uniq
               else
                 host.hostgroup ? host.hostgroup.path.each.map { |hg| hg.puppet&.config_group_ids }.compact.flatten.uniq : []
               end
      ForemanPuppet::ConfigGroupClass.where(config_group_id: (config_group_ids + cg_ids)).pluck(:puppetclass_id)
    end

    def hg_class_ids
      hg_ids = if is_a?(HostgroupPuppetFacet)
                 hostgroup.path_ids
               elsif host.hostgroup
                 host.hostgroup.path_ids
               end
      ForemanPuppet::HostgroupClass.joins(:hostgroup_puppet_facet)
                                   .where(ForemanPuppet::HostgroupPuppetFacet.arel_table[:hostgroup_id].in(hg_ids))
                                   .pluck(:puppetclass_id)
    end

    def host_class_ids
      (is_a?(ForemanPuppet::HostPuppetFacet) ? host_classes : hostgroup_classes).map(&:puppetclass_id)
    end

    def all_puppetclass_ids
      cg_class_ids + hg_class_ids + host_class_ids
    end

    def classes(env = environment)
      conditions = { id: all_puppetclass_ids }
      if env
        env.puppetclasses.where(conditions)
      else
        ForemanPuppet::Puppetclass.where(conditions)
      end
    end

    def puppetclass_ids
      classes.reorder('').pluck('puppetclasses.id')
    end

    def classes_in_groups
      conditions = { id: cg_class_ids }
      if environment
        environment.puppetclasses.where(conditions) - parent_classes
      else
        ForemanPuppet::Puppetclass.where(conditions) - parent_classes
      end
    end

    # Returns Puppetclasses of a Host or Hostgroup
    #
    # It does not include Puppetclasses of it's ConfigGroupClasses
    #
    def individual_puppetclasses
      ids = host_class_ids - cg_class_ids
      return puppetclasses if ids.blank? && new_record?
      ForemanPuppet::Puppetclass.includes(:environments).where(id: ids)
    end

    def available_puppetclasses
      return ForemanPuppet::Puppetclass.all.authorized(:view_puppetclasses) if environment.blank?
      environment.puppetclasses - parent_classes
    end

    def puppetca?
      return false if respond_to?(:managed?) && !managed?
      puppetca_exists?
    end

    def puppetca_exists?
      !!(puppet_ca_proxy && puppet_ca_proxy.url.present?)
    end

    def puppet_server_uri
      return unless puppet_proxy
      url = puppet_proxy.setting('Puppet', 'puppet_url')
      url ||= "https://#{puppet_proxy}:8140"
      URI(url)
    end

    # The Puppet server FQDN or an empty string. Exposed as a provisioning macro
    def puppet_server
      puppet_server_uri.try(:host) || ''
    end
    alias_method :puppetmaster, :puppet_server

    def puppet_ca_server_uri
      return unless puppet_ca_proxy
      url = puppet_ca_proxy.setting('Puppet CA', 'puppet_url')
      url ||= "https://#{puppet_ca_proxy}:8140"
      URI(url)
    end

    # The Puppet CA server FQDN or an empty string. Exposed as a provisioning
    # macro.
    def puppet_ca_server
      puppet_ca_server_uri.try(:host) || ''
    end

    private

    # fall back to our puppet proxy in case our puppet ca is not defined/used.
    def check_puppet_ca_proxy_is_required?
      return true if puppet_ca_proxy_id.present? || puppet_proxy_id.blank?
      self.puppet_ca_proxy ||= puppet_proxy if puppet_proxy.has_feature?('Puppet CA')
    rescue StandardError
      true # we don't want to break anything, so just skipping.
    end
  end
end
