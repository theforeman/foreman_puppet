require 'rake/testtask'

# Tests
namespace :test do
  desc 'Test ForemanPuppet'
  Rake::TestTask.new(:foreman_puppet) do |t|
    test_dir = File.expand_path('../../test', __dir__)
    t.libs << 'test'
    t.libs << test_dir
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

Rake::Task[:test].enhance ['test:foreman_puppet']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_puppet']
end
