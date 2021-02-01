require 'test_puppet_helper'

module ForemanPuppet
  class HostsAndHostgroupsHelperTest < ActionView::TestCase
    include ::ApplicationHelper
    include ::FormHelper
    include ::HostsHelper

    include HostsAndHostgroupsHelper

    describe 'puppet environment field' do
      setup do
        @host = mock('host')
        puppet = mock('puppet')
        @host.stubs(:hostgroup)
        @host.stubs(:puppet).returns(puppet)
        @host.stubs(:id).returns(999)
        @f = mock('f')
        @f.stubs(:object).returns(@host)
        @fields = mock('fields')
        @fields.stubs(:object).returns(puppet)
        @f.stubs(:fields_for).yields(@fields)
      end

      test 'it adds new first level attributes' do
        @fields.expects(:collection_select).with do |*attrs|
          select_options, html_options = extract_collection_options(attrs)
          select_options[:test_select_option] == 'test_value1' &&
            html_options[:test_html_option] == 'test_value2'
        end

        host_puppet_environment_field(@f, { test_select_option: 'test_value1' }, { test_html_option: 'test_value2' })
      end

      test 'it adds new data attributes' do
        @fields.expects(:collection_select).with do |*attrs|
          select_options, html_options = extract_collection_options(attrs)
          select_options[:test_select_option] == 'test_value1' &&
            html_options[:data][:test] == 'test_value2'
        end

        host_puppet_environment_field(@f, { test_select_option: 'test_value1' }, { data: { test: 'test_value2' } })
      end

      test 'it overrides existing attributes' do
        @fields.expects(:collection_select).with do |*attrs|
          html_options = attrs.pop
          html_options[:data][:test] == 'some_test_value' &&
            html_options[:data][:url] == '/test/url'
        end.returns('')

        html = host_puppet_environment_field(@f, { disable_button: false }, { data: { url: '/test/url', test: 'some_test_value' } })

        assert_no_match(/btn/, html)
      end
    end

    private

    def extract_collection_options(attrs)
      html_opts = attrs.pop
      [attrs.pop, html_opts]
    end
  end
end
