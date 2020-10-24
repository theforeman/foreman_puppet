require 'test_puppet_enc_helper'
require 'integration_test_helper'

module ForemanPuppetEnc
  class HostJSTest < IntegrationTestWithJavascript
    describe 'hosts index multiple actions' do
      setup do
        @entries = Setting[:entries_per_page]
        hosts
      end

      teardown do
        Setting[:entries_per_page] = @entries
      end

      let(:environment) { FactoryBot.create(:environment) }
      let(:hosts) { FactoryBot.create_list(:host, 3) }

      test 'apply bulk action, change environment on all hosts' do
        environment
        Setting[:entries_per_page] = 3
        visit hosts_path(per_page: 2)
        check 'check_all'
        find('#multiple-alert > .text > a').click
        find('#submit_multiple').click
        find('a', text: /\AChange Environment\z/).click
        find('#environment_id').find("option[value='#{environment.id}']").select_option
        find('button', text: /\ASubmit\z/).click
        assert page.has_text?(:all, 'Updated hosts: changed environment')
      end

      test 'redirect js' do
        visit hosts_path
        check 'check_all'

        # Ensure and wait for all hosts to be checked, and that no unchecked hosts remain
        assert page.has_no_selector?('input.host_select_boxes:not(:checked)')

        # Hosts are added to cookie
        host_ids_on_cookie = JSON.parse(CGI.unescape(get_me_the_cookie('_ForemanSelectedhosts')&.fetch(:value)))
        assert_includes(host_ids_on_cookie, hosts.first.id)

        page.execute_script("tfm.hosts.table.buildRedirect('#{foreman_puppet_enc.select_multiple_environment_hosts_path}')")
        assert_current_path(foreman_puppet_enc.select_multiple_environment_hosts_path, ignore_query: true)

        assert page.has_selector?('td', text: hosts.first.name)
      end
    end

    describe 'Puppet Classes tab' do
      context 'has inherited Puppetclasses' do
        setup do
          @hostgroup = FactoryBot.create(:hostgroup, :with_puppetclass)
          @host = FactoryBot.create(:host, hostgroup: @hostgroup, environment: @hostgroup.environment)

          visit edit_host_path(@host)
          page.find(:link, 'Puppet Classes', href: '#puppet_klasses').click
        end

        test 'it mentions the hostgroup by name in the tooltip' do
          page.find('#puppet_klasses .panel h3 a').click
          class_element = page.find('#inherited_ids>li')

          assert_equal @hostgroup.puppetclasses.first.name, class_element.text
        end

        test 'it shows a header mentioning the hostgroup inherited from' do
          header_element = page.find('#puppet_klasses .panel h3 a')

          assert header_element.text =~ /#{@hostgroup.name}$/
        end
      end
    end
  end
end
