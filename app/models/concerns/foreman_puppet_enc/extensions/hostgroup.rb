module ForemanPuppetEnc
  module Extensions
    module Hostgroup
      extend ActiveSupport::Concern

      included do
        has_one :environment, through: :hostgroup_puppet_extension
      end
    end
  end
end
