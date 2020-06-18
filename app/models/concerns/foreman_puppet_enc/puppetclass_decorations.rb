module ForemanPuppetEnc
  module PuppetclassDecorations
    extend ActiveSupport::Concern

    included do
      # param classes
      has_many :class_params, -> { where('environment_classes.puppetclass_lookup_key_id is NOT NULL').distinct },
        :through => :environment_classes, :source => :puppetclass_lookup_key
      accepts_nested_attributes_for :class_params, :reject_if => ->(a) { a[:key].blank? }, :allow_destroy => true

      alias_attribute :smart_class_parameters, :class_params
      alias_attribute :smart_class_parameter_ids, :class_param_ids

      scoped_search :relation => :class_params, :on => :key, :complete_value => true, :only_explicit => true
    end
  end
end
