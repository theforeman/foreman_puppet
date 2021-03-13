module ForemanPuppet
  module Extensions
    module Report
      extend ActiveSupport::Concern

      included do
        has_one :environment, through: :host

        # for cases when class already inherit before we apply the patch
        self.class.subclasses.each do |subclass|
          add_environment_search_to(subclass)
        end
      end

      class_methods do
        def inherited(child)
          add_environment_search_to(child)
          super
        end

        def add_environment_search_to(klass)
          klass.instance_eval do
            scoped_search relation: :environment, on: :name, complete_value: true, rename: :environment
          end
        end
      end
    end
  end
end
