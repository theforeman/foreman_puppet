module ForemanPuppetEnc
  module Extensions
    module OperatingsystemsController
      extend ActiveSupport::Concern

      def clone
        @operatingsystem = @operatingsystem.deep_clone include: %i[media ptables architectures puppetclasses os_parameters], except: [:title]
      end
    end
  end
end
