module ForemanPuppet
  module Extensions
    module HostCommon
      extend ActiveSupport::Concern

      ASSIGNMENT_RELATIONS = %i[search_puppetclasses search_config_groups].freeze

      included do
        singleton_class.prepend CompletionMethods

        has_many :search_puppetclasses, through: :puppet, source: :puppetclasses, class_name: '::ForemanPuppet::Puppetclass'
        has_many :search_config_groups, through: :puppet, source: :config_groups, class_name: '::ForemanPuppet::ConfigGroup'
      end

      module CompletionMethods
        def complete_for(query, options = {})
          return super if query.nil?

          completer = AssignmentCompleter.new(scoped_search_definition, query, options)
          return super unless completer.assignment_field?

          completer.build_autocomplete_options
        end
      end

      class AssignmentCompleter < ScopedSearch::AutoCompleteBuilder
        def assignment_field?
          return false unless complete_options(last_node).include?(:value)

          token = last_token_is(COMPARISON_OPERATORS) ? tokens[-2] : tokens[-3]
          ASSIGNMENT_RELATIONS.include?(definition.field_by_name(token)&.relation)
        end

        def completer_scope(field)
          return super unless ASSIGNMENT_RELATIONS.include?(field.relation)

          options = @options.merge(autocomplete_resource: definition.klass)
          field.klass.completer_scope(options).reorder(Arel.sql(field.quoted_field))
        end
      end

      def all_puppetclasses(env = environment)
        return ForemanPuppet::Puppetclass.none unless puppet
        puppet.all_puppetclasses(env)
      end

      def puppetclasses
        (puppet || build_puppet).puppetclasses
      end
    end
  end
end
