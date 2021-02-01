require 'test_puppet_helper'

module ForemanPuppet
  class PuppetclassLookupKeyTest < ActiveSupport::TestCase
    test 'should not update default value unless override is true' do
      lookup_key = FactoryBot.create(:puppetclass_lookup_key, override: false, default_value: 'test123')
      assert_not lookup_key.override
      lookup_key.default_value = '33333'
      assert_not lookup_key.valid?
    end

    test 'default_value is only validated if omit is false' do
      lookup_key = FactoryBot.create(:puppetclass_lookup_key, :boolean, override: true, omit: true)
      lookup_key.default_value = 'whatever'
      assert lookup_key.valid?
      lookup_key.omit = false
      assert_not lookup_key.valid?
    end

    test 'should update description when override is false' do
      lookup_key = FactoryBot.create(:puppetclass_lookup_key, override: false, description: 'description')
      assert_not lookup_key.override
      lookup_key.description = 'new_description'
      assert lookup_key.valid?
    end

    test 'should save without changes when override is false' do
      lookup_key = FactoryBot.create(:puppetclass_lookup_key, override: false,
                                                              default_value: 'test123',
                                                              description: 'description')
      assert_not lookup_key.override
      assert lookup_key.valid?
    end

    test 'should allow to uncheck override' do
      lookup_key = FactoryBot.create(:puppetclass_lookup_key, override: true)

      lookup_key.override = false
      assert lookup_key.valid?
    end

    test 'should be smart class parameter #puppet? => true' do
      assert_not_deprecated do
        assert FactoryBot.create(:puppetclass_lookup_key).puppet?
      end
    end

    context 'delete params with class' do
      let(:environment) { FactoryBot.create(:environment) }
      let(:puppetclass) { FactoryBot.create(:puppetclass, environments: [environment]) }
      let(:lookup_key) { FactoryBot.create(:puppetclass_lookup_key, puppetclass: puppetclass, override: true) }

      test 'deleting puppetclass should delete smart class parameters' do
        env2 = FactoryBot.create(:environment)
        FactoryBot.create(:environment_class, puppetclass: puppetclass, environment: env2, puppetclass_lookup_key: lookup_key)

        puppetclass.destroy
        assert_not ForemanPuppet::PuppetclassLookupKey.where(key: lookup_key.key).present?
      end

      test 'deleting only environment a smart class parameters is in should delete the parameter' do
        lookup_key
        environment.destroy
        assert_not ForemanPuppet::PuppetclassLookupKey.where(key: lookup_key.key).present?
      end

      test 'deleting only one environment a smart class parameters is in should not delete the parameter' do
        env2 = FactoryBot.create(:environment)
        FactoryBot.create(:environment_class, puppetclass: puppetclass, environment: env2, puppetclass_lookup_key: lookup_key)

        environment.destroy
        assert ForemanPuppet::PuppetclassLookupKey.where(key: lookup_key.key).present?
      end
    end

    test 'should have auditable_type as PuppetclassLookupKey and not LookupKey' do
      ForemanPuppet::PuppetclassLookupKey.create(key: 'test_audit_parameter', default_value: 'test123')
      assert_equal 'ForemanPuppet::PuppetclassLookupKey', Audit.unscoped.last.auditable_type
    end
  end
end
