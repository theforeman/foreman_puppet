module ForemanPuppet
  module Extensions
    module User
      extend ActiveSupport::Concern

      included do
        prepend PatchedMethods
      end

      module PatchedMethods
        def visible_environments
          ForemanPuppet::Environment.authorized(:view_environments).pluck(:name)
        end
      end
    end
  end
end
