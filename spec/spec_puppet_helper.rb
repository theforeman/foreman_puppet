foreman_path = ['../foreman', '../../foreman', '../../../foreman'].map { |p| File.expand_path(p, __dir__) }
foreman_path = foreman_path.detect { |path| File.exist?(File.join(path, 'Gemfile')) }
$LOAD_PATH.unshift(File.join(foreman_path, 'test'))
$LOAD_PATH.unshift(File.join(foreman_path, 'lib'))
$LOAD_PATH.unshift(File.expand_path('../test', __dir__))

ENV['RAILS_ENV'] ||= 'test'
require File.join(foreman_path, 'config', 'environment')
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'capybara/rspec'
require 'database_cleaner'
require 'factory_bot'
FactoryBot.definition_file_paths.unshift(File.join(foreman_path, 'test', 'factories'))
require 'factory_bot_rails'
FactoryBot.reload

module ViewExampleGroupExtensions
  extend ActiveSupport::Concern

  included do
    helper(LayoutHelper, AuthorizeHelper, TaxonomyHelper, PaginationHelper, ReactjsHelper)

    before do
      path = _controller_path
      controller.class.define_method(:controller_name) do
        path
      end
    end
  end

  def _controller_path
    case _path_parts[1]
    when 'puppetclasses'
      _path_parts[1..-2].join('/')
    else
      super
    end
  end

  def as_paginatable(arry)
    arry.stubs(:total_entries).returns(arry.size)
    arry
  end
end

::ActionView::TestCase::TestController.include(FindCommon)
module ::ActionView
  class TestCase
    class TestController
      helper_method :resource_path

      def resource_path(type)
        return '' if type.nil?

        path = "#{type.pluralize.underscore}_path"
        prefix, suffix = path.split('/', 2)
        if path.include?('/') && Rails.application.routes.mounted_helpers.method_defined?(prefix)
          # handle mounted engines
          engine = send(prefix)
          engine.send(suffix) if engine.respond_to?(suffix)
        else
          path = path.tr('/', '_')
          send(path) if respond_to?(path)
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.color = true
  config.fail_fast = ENV['FAIL_FAST'] || false
  config.infer_spec_type_from_file_location!
  config.mock_with :mocha
  config.raise_errors_for_deprecations!

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.fixture_path = "#{foreman_path}/test/fixtures"
  config.global_fixtures = %i[auth_sources permissions users]

  config.before :each do
    Rails.cache.clear
  end

  config.before :each do
    Setting.create!(name: 'bcrypt_cost', value: 5, default: 8, description: 'Cost of bcrypt')
    User.current = users(:admin)
  end

  config.include ViewExampleGroupExtensions, type: :view

  # Clean out the database state before the tests run
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  # Wrap all db isolated tests in a transaction
  config.around(db: :isolate) do |example|
    DatabaseCleaner.cleaning(&example)
  end
end
