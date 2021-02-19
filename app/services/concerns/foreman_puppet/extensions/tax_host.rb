module ForemanPuppet
  module Extensions
    module TaxHost
      extend ActiveSupport::Concern

      included do
        FOREIGN_KEYS << :environment_id
        HASH_KEYS << :environment_ids

        prepend PatchedMethods

        private

        # would be define by FOREIGN_KEYS.each, but it is already evaluated at the time of patching
        def environment_ids
          hosts.map{ puppet&.environment_id }.compact.uniq
        end
      end

      module PatchedMethods
        def initialize(taxonomy, hosts = nil)
          super
          @hosts = @hosts.preload(:puppet)
        end
      end
    end
  end
end
