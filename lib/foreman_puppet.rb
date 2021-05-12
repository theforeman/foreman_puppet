module ForemanPuppet
  FOREMAN_EXTRACTION_VERSION = '3.0'.freeze

  def self.extracted_from_core?
    ENV['PUPPET_EXTRACTED'] == '1' ||
      Gem::Dependency.new('', ">= #{FOREMAN_EXTRACTION_VERSION}").match?('', SETTINGS[:version].notag)
  end
end

require 'foreman_puppet/engine'
