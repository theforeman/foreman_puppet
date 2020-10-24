require 'test_puppet_enc_helper'
require 'integration_test_helper'

module ForemanPuppetEnc
  class HostJSTest < IntegrationTestWithJavascript
    let(:hostgroup) { FactoryBot.create(:hostgroup, :with_puppetclass) }

    describe 'edit form' do
      setup do
        @another_puppetclass = FactoryBot.create(:puppetclass)
      end

      context 'puppet classes are not available in the environment' do
        setup do
          hostgroup.puppetclasses << @another_puppetclass
          visit edit_hostgroup_path(hostgroup)
        end

        describe 'Puppet classes tab' do
          test 'it shows a warning' do
            click_link 'Puppet Classes'
            wait_for_ajax

            assert page.has_selector?('#puppetclasses_unavailable_warning')
          end

          test 'it marks selected classes as unavailable' do
            click_link 'Puppet Classes'
            wait_for_ajax

            assert page.has_selector?('.selected_puppetclass.unavailable')
          end
        end
      end
    end

    describe 'Form Puppet Classes tab' do
      context 'has inherited Puppetclasses' do
        setup do
          @child_hostgroup = FactoryBot.create(:hostgroup, parent: hostgroup)

          visit edit_hostgroup_path(@child_hostgroup)
          page.find(:link, 'Puppet Classes', href: '#puppet_klasses').click
        end

        test 'it mentions the parent hostgroup by name in the tooltip' do
          page.find('#puppet_klasses .panel h3 a').click
          class_element = page.find('#inherited_ids>li')

          assert_equal hostgroup.puppetclasses.first.name, class_element.text
        end

        test 'it shows a header mentioning the hostgroup inherited from' do
          header_element = page.find('#puppet_klasses .panel h3 a')
          assert header_element.text =~ /#{hostgroup.name}$/
        end
      end
    end
  end
end
