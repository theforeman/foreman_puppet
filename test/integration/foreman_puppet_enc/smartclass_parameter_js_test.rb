require_relative '../../test_puppet_enc_helper'
require 'integration_test_helper'

module ForemanPuppetEnc
  class SmartclassParameterJSTest < IntegrationTestWithJavascript
    include ForemanPuppetEnc::Engine.routes.url_helpers

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

    test 'edit page' do
      FactoryBot.create(:puppetclass_lookup_key, key: 'ssl')
      visit puppetclass_lookup_keys_path
      within(:xpath, '//table') do
        click_link 'ssl'
      end
      fill_in 'puppetclass_lookup_key_description', with: 'test'
      fill_in 'puppetclass_lookup_key_default_value', with: 'false'
      assert_submit_button(puppetclass_lookup_keys_path)
      assert page.has_link? 'ssl'
    end
  end
end
