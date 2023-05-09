require File.expand_path('lib/foreman_puppet/version', __dir__)

Dir['locale/**/*.po'].each do |po|
  mo = po.sub(/foreman_puppet\.po$/, 'LC_MESSAGES/foreman_puppet.mo')
  warn "WARNING: File #{mo} does not exist, generate with 'make all-mo'!" unless File.exist?(mo)
  warn "WARNING: File #{mo} outdated, regenerate with 'make all-mo'" if File.mtime(po) > File.mtime(mo)
end

Gem::Specification.new do |s|
  s.name        = 'foreman_puppet'
  s.version     = ForemanPuppet::VERSION
  s.license     = 'GPL-3.0'
  s.authors     = File.readlines(File.expand_path('AUTHORS', __dir__), encoding: 'utf-8').map(&:strip)
  s.email       = ['foreman-dev@googlegroups.com']
  s.homepage    = 'https://github.com/theforeman/foreman_puppet'
  s.summary     = 'Add Puppet features to Foreman'
  # also update locale/gemspec.rb
  s.description = 'Allow assigning Puppet environments and classes to the Foreman Hosts.'

  s.files = Dir['{app,config,db,lib,locale,webpack}/**/*'] + ['LICENSE', 'Rakefile', 'README.md', 'package.json']
  s.test_files = Dir['test/**/*']
end
