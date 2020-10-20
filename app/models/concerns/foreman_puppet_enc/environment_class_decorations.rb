module ForemanPuppetEnc
  module EnvironmentClassDecorations
    extend ActiveSupport::Concern

    included do
      plk = reflect_on_association(:puppetclass_lookup_key)
      plk.instance_variable_set(:@class_name, 'ForemanPuppetEnc::PuppetclassLookupKey')
    end
  end
end
