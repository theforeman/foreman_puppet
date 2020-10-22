module ForemanPuppetEnc
  FOREMAN_EXTRACTION_VERSION = '2.4'.freeze

  def self.extracted_from_core?
    ENV['PUPPET_EXTRACTED'] == '1' ||
      Gem::Dependency.new('', ">= #{FOREMAN_EXTRACTION_VERSION}").match?('', SETTINGS[:version])
  end
end

require 'foreman_puppet_enc/engine'
