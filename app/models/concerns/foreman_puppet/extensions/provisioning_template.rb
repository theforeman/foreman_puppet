module ForemanPuppet
  module Extensions
    module ProvisioningTemplate
      extend ActiveSupport::Concern

      included do
        if ForemanPuppet.extracted_from_core?
          has_many :environments, through: :template_combinations
          before_destroy EnsureNotUsedBy.new(:environments)

          scoped_search relation: :environments, on: :name, rename: :environment, complete_value: true

          class << base
            prepend PrependedClassMethods
          end

          prepend PrependedMethods
        else
          env_assoc = reflect_on_association(:environments)
          env_assoc&.instance_variable_set(:@class_name, 'ForemanPuppet::Environment')
        end
      end

      module PrependedClassMethods
        def templates_by_template_combinations(templates, hosts_or_conditions)
          if hosts_or_conditions.is_a?(Hash)
            conditions = hosts_or_conditions
            conditions[:hostgroup_id] = Array.wrap(conditions[:hostgroup_id]) | [nil]
            conditions[:environment_id] = Array.wrap(conditions[:environment_id]) | [nil]
          else
            conditions = {}
            conditions[:hostgroup_id] = hosts_or_conditions.pluck(:hostgroup_id) | [nil]
            conditions[:environment_id] = hosts_or_conditions.pluck(:environment_id) | [nil]
          end
          at = TemplateCombination.arel_table
          arel = at[:hostgroup_id].in(conditions[:hostgroup_id])
          arel = arel.and(at[:environment_id].in(conditions[:environment_id]))
          templates.joins(:template_combinations).where(arel).distinct
        end

        def template_includes
          includes = super
          tc_include = includes.detect { |i| i.key?(:template_combinations) }
          tc_include ||= includes << {}
          tc_include[:template_combinations] = %i[hostgroup environment]
          includes
        end
      end

      module PrependedMethods
        def reject_template_combination_attributes?(params)
          params[:environment_id].blank? && super(params)
        end

        # check if our template is a snippet, and remove its associations just in case they were selected.
        def check_for_snippet_assoications
          super
          return unless snippet
          environments.clear
        end
      end
    end
  end
end
