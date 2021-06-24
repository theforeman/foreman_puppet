module ForemanPuppet
  module Extensions
    module Operatingsystem
      extend ActiveSupport::Concern

      included do
        has_and_belongs_to_many :puppetclasses, class_name: 'ForemanPuppet::Puppetclass'
      end
    end
  end
end
