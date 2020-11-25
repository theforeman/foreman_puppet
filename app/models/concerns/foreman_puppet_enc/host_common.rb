module ForemanPuppetEnc
  # Common methods between host and hostgroup
  # mostly for template rendering consistency
  module HostCommon
    extend ActiveSupport::Concern

    included do
      belongs_to :environment, class_name: 'ForemanPuppetEnc::Environment'
      has_many :host_config_groups, as: :host, dependent: :destroy
      has_many :config_groups, through: :host_config_groups
      has_many :config_group_classes, through: :config_groups
      has_many :group_puppetclasses, through: :config_groups, source: :puppetclasses

      alias_method :all_puppetclasses, :classes
    end

    def parent_name
      if is_a?(HostPuppetFacet)
        host.hostgroup&.name
      elsif is_a?(HostgroupPuppetFacet)
        hostgroup.parent&.name
      end
    end

    def cg_class_ids
      cg_ids = if is_a?(HostgroupPuppetFacet)
                 hostgroup.path.each.map(&:config_group_ids).flatten.uniq
               else
                 host.hostgroup ? host.hostgroup.path.each.map(&:config_group_ids).flatten.uniq : []
               end
      ConfigGroupClass.where(config_group_id: (config_group_ids + cg_ids)).pluck(:puppetclass_id)
    end

    def hg_class_ids
      hg_ids = if is_a?(HostgroupPuppetFacet)
                 hostgroup.path_ids
               elsif host.hostgroup
                 host.hostgroup.path_ids
               end
      ForemanPuppetEnc::HostgroupClass.joins(:hostgroup_puppet_facet).where(HostgroupPuppetFacet.arel_table[:hostgroup_id].in(hg_ids)).pluck(:puppetclass_id)
    end

    def host_class_ids
      (is_a?(HostPuppetFacet) ? host_classes : hostgroup_classes).map(&:puppetclass_id)
    end

    def all_puppetclass_ids
      cg_class_ids + hg_class_ids + host_class_ids
    end

    def classes(env = environment)
      conditions = { id: all_puppetclass_ids }
      if env
        env.puppetclasses.where(conditions)
      else
        Puppetclass.where(conditions)
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
        Puppetclass.where(conditions) - parent_classes
      end
    end

    # Returns Puppetclasses of a Host or Hostgroup
    #
    # It does not include Puppetclasses of it's ConfigGroupClasses
    #
    def individual_puppetclasses
      ids = host_class_ids - cg_class_ids
      return puppetclasses if ids.blank? && new_record?
      Puppetclass.includes(:environments).where(id: ids)
    end

    def available_puppetclasses
      return Puppetclass.all.authorized(:view_puppetclasses) if environment.blank?
      environment.puppetclasses - parent_classes
    end
  end
end
