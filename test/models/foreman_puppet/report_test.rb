require 'test_puppet_helper'

module ForemanPuppet
  class TestReport < ::Report
  end

  class ReportTest < ActiveSupport::TestCase
    test 'Inherited children can search by environment' do
      assert_nothing_raised do
        TestReport.search_for('environment = blah')
      end
    end

    # to include the environment search
    test 'Inherited children can search' do
      assert_nothing_raised do
        TestReport.search_for('blah')
      end
    end
  end
end
