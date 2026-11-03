require 'integration_puppet_helper'

module ForemanPuppet
  class PuppetclassLookupKeysIntegrationTest < ActionDispatch::IntegrationTest
    include ForemanPuppet::Engine.routes.url_helpers

    test 'saves overrides whose nested form exceeds 4096 parameters' do
      lookup_key = FactoryBot.create(:puppetclass_lookup_key, :integer, path: 'comment')
      values = Array.new(1400) do |index|
        { 'match' => "comment=override#{index}", 'value' => index.to_s, 'omit' => '0' }
      end
      nested_values = values.each_with_index.to_h { |value, index| [index.to_s, value] }
      nested_body = Rack::Utils.build_nested_query(
        'puppetclass_lookup_key' => { 'lookup_values_attributes' => nested_values },
        '_method' => 'patch'
      )
      assert_operator nested_body.split('&').size, :>, 4096

      body = Rack::Utils.build_nested_query(
        'puppetclass_lookup_key' => { 'lookup_values_json' => values.to_json },
        '_method' => 'patch'
      )

      # An encoded body exercises Rack parsing and method override before routing.
      cookies[:test_user] = users(:admin).login
      post puppetclass_lookup_key_path(lookup_key), params: body,
        headers: { 'CONTENT_TYPE' => 'application/x-www-form-urlencoded' }

      assert_redirected_to puppetclass_lookup_keys_path
      assert_equal 'PATCH', request.request_method
      overrides = lookup_key.reload.lookup_values
      assert_equal values.size, overrides.count
      assert_equal values.map { |value| [value['match'], value['value'].to_i, false] }.sort,
        overrides.pluck(:match, :value, :omit).sort
    end
  end
end
