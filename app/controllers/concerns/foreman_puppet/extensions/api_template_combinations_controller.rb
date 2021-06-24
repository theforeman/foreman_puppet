module ForemanPuppet
  module Extensions
    module ApiTemplateCombinationsController
      extend ActiveSupport::Concern

      included do
        if ForemanPuppet.extracted_from_core?
          apipie_update_methods(%i[index create show update]) do
            param :environment_id, nil, desc: N_('ID of environment')
          end
        end

        prepend PrependedMethods
      end

      module PrependedMethods
        def allowed_nested_id
          super | ['environment_id']
        end
      end
    end
  end
end
