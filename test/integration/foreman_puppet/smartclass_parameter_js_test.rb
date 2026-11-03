require 'integration_puppet_helper'

module ForemanPuppet
  class SmartclassParameterJSTest < IntegrationTestWithJavascript
    include ForemanPuppet::Engine.routes.url_helpers

    # intermittent failures:
    #   PuppetclassLookupKeyJSTest.test_0001_can hide value when overriden
    #   PuppetclassLookupKeyJSTest.test_0002_uncheck override

    test 'index page' do
      FactoryBot.create(:puppetclass_lookup_key, key: 'ssl')
      assert_index_page(puppetclass_lookup_keys_path, 'Smart Class Parameters', false)
    end

    test 'can hide value when overriden' do
      FactoryBot.create(:puppetclass_lookup_key, key: 'port', override: false)
      visit puppetclass_lookup_keys_path
      within(:xpath, '//table') do
        click_link 'port'
      end
      page.find('#puppetclass_lookup_key_override').click
      assert page.find('#puppetclass_lookup_key_hidden_value:enabled')
    end

    test 'does not turn empty boolean value to false' do
      FactoryBot.create(:puppetclass_lookup_key, key: 'ssl')
      visit puppetclass_lookup_keys_path
      within(:xpath, '//table') do
        click_link 'ssl'
      end

      page.find('.add_nested_fields').click
      row = page.first('.lookup_values table tbody tr')
      row.find('.matcher_key').select('os')
      row.find('.matcher_value').set('fake')
      wait_for_ajax

      click_button('Submit')
      assert page.has_selector?('.has-error')
    end

    test 'uncheck override' do
      FactoryBot.create(:puppetclass_lookup_key, key: 'ssl')
      visit puppetclass_lookup_keys_path
      within(:xpath, '//table') do
        click_link 'ssl'
      end

      page.find('#puppetclass_lookup_key_hidden_value').click

      assert_submit_button(puppetclass_lookup_keys_path)
      wait_for_ajax

      within(:xpath, '//table') do
        click_link 'ssl'
      end

      page.find('#puppetclass_lookup_key_override').click

      assert_submit_button(puppetclass_lookup_keys_path)
      wait_for_ajax

      within(:xpath, '//table') do
        click_link 'ssl'
      end

      assert page.find('#puppetclass_lookup_key_hidden_value').checked?
    end

    test 'creates updates removes and omits matcher overrides on the standalone edit page' do
      lookup_key = FactoryBot.create(:puppetclass_lookup_key, :integer, path: 'comment',
        overrides: { 'comment=updated' => 2, 'comment=removed' => 3, 'comment=omitted' => 4 })
      visit edit_puppetclass_lookup_key_path(lookup_key)
      work_around_selenium_file_detector_bug

      within_matcher('comment=updated') { fill_in 'Value', with: '8' }
      within_matcher('comment=removed') { click_link 'Remove Matcher' }
      within_matcher('comment=omitted') { check }

      click_link '+ Add Matcher'
      within_matcher('') do
        select 'comment'
        fill_in type: 'text', with: 'added'
        fill_in 'Value', with: '5'
      end
      assert_submit_button(puppetclass_lookup_keys_path)

      overrides = lookup_key.reload.lookup_values
      assert_equal [['comment=added', 5, false], ['comment=omitted', 4, true], ['comment=updated', 8, false]],
        overrides.pluck(:match, :value, :omit).sort

      visit edit_puppetclass_lookup_key_path(lookup_key)
      within_matcher('comment=updated') { assert_field 'Value', with: '8' }
      within_matcher('comment=omitted') do
        assert_checked_field
        assert_field 'Value', with: '4', disabled: true
      end
    end

    test 'edit page' do
      FactoryBot.create(:puppetclass_lookup_key, key: 'ssl')
      visit puppetclass_lookup_keys_path
      within(:xpath, '//table') do
        click_link 'ssl'
      end
      # see: https://projects.theforeman.org/issues/37251
      page.driver.browser.file_detector = nil if page.driver.browser.respond_to?(:file_detector=)
      fill_in 'puppetclass_lookup_key_description', with: 'test'
      fill_in 'puppetclass_lookup_key_default_value', with: 'false'
      assert_submit_button(puppetclass_lookup_keys_path)
      assert page.has_link? 'ssl'
    end

    private

    def within_matcher(match, &block)
      row = find('tr.matchers') do |candidate|
        candidate.find('input.match', visible: false).value == match
      end
      within(row, &block)
    end
  end
end
