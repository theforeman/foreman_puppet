require File.expand_path('lib/foreman_puppet/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'foreman_puppet'
  s.version     = ForemanPuppet::VERSION
  s.license     = 'GPL-3.0'
  s.authors     = IO.readlines(File.expand_path('AUTHORS', __dir__), encoding: 'utf-8').map(&:strip)
  s.email       = ['foreman-dev@googlegroups.com']
  s.homepage    = 'https://github.com/theforeman/foreman_puppet'
  s.summary     = 'Adds puppet ENC features'
  # also update locale/gemspec.rb
  s.description = 'Allow assigning Puppet environmets and classes to the Foreman Hosts.'

  s.files = Dir['{app,config,db,lib,locale,webpack}/**/*'] + ['LICENSE', 'Rakefile', 'README.md', 'package.json']
  s.test_files = Dir['test/**/*']
end
