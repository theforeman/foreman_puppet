module ForemanPuppetEnc
  # Common methods between host and hostgroup
  # mostly for template rendering consistency
  module HostCommon
    extend ActiveSupport::Concern

    included do
      has_many :host_config_groups, :as => :host, :dependent => :destroy
      has_many :config_groups, :through => :host_config_groups
      has_many :config_group_classes, :through => :config_groups
      has_many :group_puppetclasses, :through => :config_groups, :source => :puppetclasses
    end

    class_methods do
      def cg_class_ids
        cg_ids = if is_a?(Hostgroup)
                   path.each.map(&:config_group_ids).flatten.uniq
                 else
                   hostgroup ? hostgroup.path.each.map(&:config_group_ids).flatten.uniq : []
                 end
        ConfigGroupClass.where(:config_group_id => (config_group_ids + cg_ids)).pluck(:puppetclass_id)
      end

      def hg_class_ids
        hg_ids = if is_a?(Hostgroup)
                   path_ids
                 elsif hostgroup
                   hostgroup.path_ids
                 end
        HostgroupClass.where(:hostgroup_id => hg_ids).pluck(:puppetclass_id)
      end

      def host_class_ids
        (is_a?(Host::Base) ? host_classes : hostgroup_classes).map(&:puppetclass_id)
      end

      def all_puppetclass_ids
        cg_class_ids + hg_class_ids + host_class_ids
      end
    end
  end
end
