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

    def cg_class_ids
      cg_ids = if is_a?(Hostgroup)
                 path.each.map(&:config_group_ids).flatten.uniq
               else
                 hostgroup ? hostgroup.path.each.map(&:config_group_ids).flatten.uniq : []
               end
      ConfigGroupClass.where(config_group_id: (config_group_ids + cg_ids)).pluck(:puppetclass_id)
    end

    def hg_class_ids
      hg_ids = if is_a?(Hostgroup)
                 path_ids
               elsif hostgroup
                 hostgroup.path_ids
               end
      HostgroupClass.where(hostgroup_id: hg_ids).pluck(:puppetclass_id)
    end

    def host_class_ids
      (is_a?(Host::Base) ? host_classes : hostgroup_classes).map(&:puppetclass_id)
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
