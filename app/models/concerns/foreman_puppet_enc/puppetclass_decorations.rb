module ForemanPuppetEnc
  module PuppetclassDecorations
    extend ActiveSupport::Concern

    included do
      plk = reflect_on_association(:environment_classes)
      plk.instance_variable_set(:@class_name, 'ForemanPuppetEnc::EnvironmentClass')
    end
  end
end
