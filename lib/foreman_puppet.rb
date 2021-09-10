module ForemanPuppet
  FOREMAN_EXTRACTION_VERSION = '2.6'.freeze
  FOREMAN_DROP_MIGRATIONS_VERSION = '3.1'.freeze

  def self.extracted_from_core?
    ENV['PUPPET_EXTRACTED'].to_s == '1' ||
      Gem::Dependency.new('', ">= #{FOREMAN_EXTRACTION_VERSION}").match?('', SETTINGS[:version].notag)
  end
end

require 'foreman_puppet/engine'
