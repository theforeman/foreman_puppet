module ForemanPuppet
  module InputType
    class PuppetParameterInput < ::InputType::Base
      class Resolver < ::InputType::Base::Resolver
        def ready?
          @scope.host &&
            enc_parameters.key?(@input.puppet_class_name) &&
            enc_parameters[@input.puppet_class_name].is_a?(Hash) &&
            enc_parameters[@input.puppet_class_name].key?(@input.puppet_parameter_name)
        end

        def resolved_value
          enc_parameters[@input.puppet_class_name][@input.puppet_parameter_name]
        end

        private

        def enc_parameters
          @enc_parameters ||= ForemanPuppet::HostInfoProviders::PuppetInfo.new(@scope.host).puppetclass_parameters
        end
      end

      def self.humanized_name
        _('Puppet parameter')
      end

      attributes :puppet_class_name, :puppet_parameter_name

      def validate(input)
        input.errors.add(:puppet_class_name, :blank) if input.puppet_class_name.blank?
        input.errors.add(:puppet_parameter_name, :blank) if input.puppet_parameter_name.blank?
      end
    end
  end
end
