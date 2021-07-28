module ForemanPuppet
  module Token
    class Puppetca < ::Token
      validates :value, uniqueness: true
    end
  end
end
