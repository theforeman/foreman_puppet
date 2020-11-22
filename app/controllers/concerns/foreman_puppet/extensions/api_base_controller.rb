module ForemanPuppet
  module Extensions
    module ApiBaseController
      extend ActiveSupport::Concern

      included do
        prepend PatchMethods

        before_action :prepare_views
      end

      def prepare_views
        prepend_view_path ForemanPuppet::Engine.root.join('app', 'prepend_views')
      end

      module PatchMethods
        def resource_name(resource = controller_name)
          case resource
          when 'environment'
            'foreman_puppet/environment'
          else
            super
          end
        end
      end
    end
  end
end
