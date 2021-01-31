module ForemanPuppetEnc
  module Extensions
    module Operatingsystem
      extend ActiveSupport::Concern

      included do
        has_and_belongs_to_many :puppetclasses
      end
    end
  end
end
