# This calls the main test_helper in Foreman-core
require 'test_helper'

# Add plugin to FactoryBot's paths
FactoryBot.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
FactoryBot.reload

# rubocop:disable Style/ClassAndModuleChildren
class ActionController::TestCase
  # used in basic_rest_response_test and is undefined with our paths
  def root_url
    '/'
  end
end
# rubocop:enable Style/ClassAndModuleChildren
