module ForemanPuppet
  class Token::Puppetca < ::Token
    validates :value, uniqueness: true
  end
end
