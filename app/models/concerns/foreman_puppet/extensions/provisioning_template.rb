module ForemanPuppet
  module Extensions
    module ProvisioningTemplate
      extend ActiveSupport::Concern

      included do
        has_many :environments, through: :template_combinations
        before_destroy EnsureNotUsedBy.new(:environments)
        before_save :remove_snippet_associations

        scoped_search relation: :environments, on: :name, rename: :environment, complete_value: true

        class << self
          prepend PrependedClassMethods
        end

        prepend PrependedMethods
      end

      module PrependedClassMethods
        def templates_by_template_combinations(templates, hosts_or_conditions)
          if hosts_or_conditions.is_a?(Hash)
            conditions = []
            if hosts_or_conditions[:hostgroup_id] && hosts_or_conditions[:environment_id]
              conditions << { hostgroup_id: Array.wrap(hosts_or_conditions[:hostgroup_id]), environment_id: Array.wrap(hosts_or_conditions[:environment_id]) }
            end
            conditions << { hostgroup_id: Array.wrap(hosts_or_conditions[:hostgroup_id]), environment_id: [nil] } if hosts_or_conditions[:hostgroup_id]
            conditions << { hostgroup_id: [nil], environment_id: Array.wrap(hosts_or_conditions[:environment_id]) } if hosts_or_conditions[:environment_id]
          else
            conditions = [{
              hostgroup_id: hosts_or_conditions.pluck(:hostgroup_id) | [nil],
              environment_id: hosts_or_conditions.joins(:puppet).pluck('host_puppet_facets.environment_id') | [nil],
            }]
          end
          tpls = templates.where('1=0')
          conditions.each do |cond|
            tpls = templates.joins(:template_combinations).where(template_combinations: cond).distinct
            return tpls if tpls.any?
          end
          tpls
        end

        def template_includes
          includes = super
          tc_include = includes.detect { |i| i.is_a?(Hash) && i.key?(:template_combinations) }
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
        def remove_snippet_associations
          return unless snippet

          environments.clear
        end
      end
    end
  end
end
