require File.expand_path('lib/foreman_puppet_enc/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'foreman_puppet_enc'
  s.version     = ForemanPuppetEnc::VERSION
  s.license     = 'GPL-3.0'
  s.authors     = IO.readlines('AUTHORS', encoding: 'utf-8').map(&:strip)
  s.email       = ['foreman-dev@googlegroups.com']
  s.homepage    = 'https://theforeman.org'
  s.summary     = 'Adds puppet ENC features'
  # also update locale/gemspec.rb
  s.description = 'Allow assigning Puppet environmets and classes to the Foreman Hosts.'

  s.files = Dir['{app,config,db,lib,locale,webpack}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rdoc'
end
