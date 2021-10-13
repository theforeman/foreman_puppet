module ForemanPuppet
  module Extensions
    module ApiTemplateCombinationsController
      extend ActiveSupport::Concern

      included do
        if Gem::Dependency.new('', '>= 3.1').match?('', SETTINGS[:version].notag)
          index_desc = Apipie.get_method_description(self, :index)
          index_desc.apis << Apipie::MethodDescription::Api.new(:GET, '/environments/:environment_id/template_combinations', N_('List template combination'), {})

          create_desc = Apipie.get_method_description(self, :create)
          create_desc.apis << Apipie::MethodDescription::Api.new(:POST, '/environments/:environment_id/template_combinations', N_('Add a template combination'), {})

          show_desc = Apipie.get_method_description(self, :show)
          show_desc.apis << Apipie::MethodDescription::Api.new(:GET, '/environments/:environment_id/template_combinations/:id', N_('Show template combination'), {})

          update_desc = Apipie.get_method_description(self, :update)
          update_desc.apis << Apipie::MethodDescription::Api.new(:PUT, '/environments/:environment_id/template_combinations/:id', N_('Update template combination'), {})

          apipie_update_methods(%i[index create show update]) do
            param :environment_id, String, desc: N_('ID of Puppet environment')
          end

          apipie_update_methods(%i[create update]) do
            param :template_combination, Hash do
              param :environment_id, :number, allow_nil: true, desc: N_('environment id')
            end
          end
        elsif ForemanPuppet.extracted_from_core?
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
