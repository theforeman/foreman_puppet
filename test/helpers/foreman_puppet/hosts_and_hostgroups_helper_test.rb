require 'test_puppet_helper'

module ForemanPuppet
  class HostsAndHostgroupsHelperTest < ActionView::TestCase
    include ::ApplicationHelper
    include ::FormHelper
    include ::HostsHelper

    include HostsAndHostgroupsHelper

    describe 'puppet environment field' do
      let(:fields) { mock('fields_for') }
      let(:f) { mock('form_for') }
      let(:object) { mock('object') }
      let(:puppet_facet) { mock('puppet') }

      setup do
        f.stubs(:object).returns(object)
        f.stubs(:fields_for).yields(fields)
        fields.stubs(:object).returns(puppet_facet)
      end

      describe '#host_puppet_environment_field' do
        let(:object) do
          host = mock('host')
          host.stubs(:hostgroup)
          host.stubs(:puppet).returns(puppet_facet)
          host.stubs(:id).returns(999)
          host
        end

        test 'it adds new first level attributes' do
          fields.expects(:collection_select).with do |*attrs|
            select_options, html_options = extract_collection_options(attrs)
            select_options[:test_select_option] == 'test_value1' &&
              html_options[:test_html_option] == 'test_value2'
          end

          host_puppet_environment_field(f, { test_select_option: 'test_value1' }, { test_html_option: 'test_value2' })
        end

        test 'it adds new data attributes' do
          fields.expects(:collection_select).with do |*attrs|
            select_options, html_options = extract_collection_options(attrs)
            select_options[:test_select_option] == 'test_value1' &&
              html_options[:data][:test] == 'test_value2'
          end

          host_puppet_environment_field(f, { test_select_option: 'test_value1' }, { data: { test: 'test_value2' } })
        end

        test 'it overrides existing attributes' do
          fields.expects(:collection_select).with do |*attrs|
            html_options = attrs.pop
            html_options[:data][:test] == 'some_test_value' &&
              html_options[:data][:url] == '/test/url'
          end.returns('')

          html = host_puppet_environment_field(f, { disable_button: false }, { data: { url: '/test/url', test: 'some_test_value' } })

          assert_no_match(/btn/, html)
        end
      end

      describe '#hostgroup_puppet_environment_field' do
        let(:object) { FactoryBot.build_stubbed(:hostgroup, parent: parent_hg) }
        let(:puppet_facet) { object.puppet || object.build_puppet }

        context 'parent without puppet' do
          let(:parent_hg) { FactoryBot.create(:hostgroup) }

          it 'shows Inherit option with no value' do
            fields.expects(:collection_select).with do |*attrs|
              options = attrs.second
              options.first.to_label == 'Inherit parent (no value)'
            end.returns('')

            hostgroup_puppet_environment_field(f)
          end
        end

        context 'parent with puppet' do
          let(:parent_hg) { FactoryBot.create(:hostgroup, :with_puppet_enc) }

          it 'shows Inherit option with no value' do
            fields.expects(:collection_select).with do |*attrs|
              options = attrs.second
              options.first.to_label == "Inherit parent (#{parent_hg.puppet.environment.name})"
            end.returns('')

            hostgroup_puppet_environment_field(f)
          end
        end
      end
    end

    private

    def extract_collection_options(attrs)
      html_opts = attrs.pop
      [attrs.pop, html_opts]
    end
  end
end
