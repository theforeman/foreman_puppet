if ENV.fetch('BUNDLE_FOREMAN', '1') == '0'
  source 'https://rubygems.org'
else
  foreman_path = Dir['./foreman', '../foreman', '../../foreman']
  foreman_path.map! { |path| File.join(path, 'Gemfile') }
  foreman_gemfile = foreman_path.detect { |p| File.exist?(p) }
  raise 'Foreman have not been found!' unless foreman_gemfile

  foreman_gemfile = File.expand_path(foreman_gemfile)
  eval_gemfile foreman_gemfile

  # remove deps, we want to redefine
  temporary_deletes = %w[theforeman-rubocop]
  temporary_deletes.concat(%w[foreman_puppet]).each do |dep_name|
    dep = dependencies.detect { |d| d.name == dep_name }
    dependencies.delete(dep) if dep
  end
end

gemspec

gem 'theforeman-rubocop', '~> 0.1.1', groups: %i[development rubocop]
