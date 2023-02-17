#!/usr/bin/env rake
foreman_path = Dir['./foreman', '../foreman', '../../foreman']
foreman_path.select! { |path| File.exist?(File.join(path, 'Gemfile')) }
raise 'Foreman have not been found!' unless foreman_path.any?
foreman_path = File.expand_path(foreman_path.first, __dir__)

# for migrations to work from 'app:db:migrate'
task 'dynflow:migrate' => 'app:dynflow:migrate'
task 'parameters:reset_priorities' => 'app:parameters:reset_priorities'

APP_RAKEFILE = File.expand_path('Rakefile', foreman_path)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(test: 'app:db:test:prepare') do |t|
  t.libs << 'test'
  t.libs << File.join(foreman_path, 'lib')
  t.libs << File.join(foreman_path, 'test')
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task default: :test
