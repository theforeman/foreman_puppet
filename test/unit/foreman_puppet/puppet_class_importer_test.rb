require 'test_puppet_helper'

module ForemanPuppet
  class PuppetClassImporterTest < ActiveSupport::TestCase
    def setup
      FactoryBot.create(:environment, name: 'production')
      ProxyAPI::Puppet.any_instance.stubs(:environments).returns(%w[foreman-testing foreman-testing-1])
      ProxyAPI::Puppet.any_instance.stubs(:classes).returns(mocked_classes)
      User.current = users(:admin)
    end

    let(:proxy) { FactoryBot.create(:puppet_smart_proxy) }
    let(:importer) { PuppetClassImporter.new(url: proxy.url) }
    let(:importer_with_proxy_api) do
      classes = {
        'ignored-class' => {},
        'not-ignored-class' => {},
      }
      proxy_api = ProxyAPI::Puppet.new(url: proxy.url)
      proxy_api.stubs(:classes).returns(classes)
      PuppetClassImporter.new(proxy: proxy_api)
    end

    test 'should support providing proxy' do
      klass = PuppetClassImporter.new(proxy: ProxyAPI::Puppet.new(url: proxy.url))
      assert_kind_of ProxyAPI::Puppet, klass.send(:proxy)
    end

    test 'should support providing url' do
      klass = PuppetClassImporter.new(url: proxy.url)
      assert_kind_of ProxyAPI::Puppet, klass.send(:proxy)
    end

    describe '#changes' do
      context 'a sepecific environment is set' do
        let(:importer) { PuppetClassImporter.new(url: proxy.url, env: 'foreman-testing') }

        test 'should contain only the specified environment in changes' do
          changes = importer.changes['new']

          assert_includes changes, 'foreman-testing'
          assert_not_includes changes, 'foreman-testing-1'
        end
      end

      context 'has ignored environments' do
        test 'it returns them' do
          importer.stubs(:ignored_environments).returns(['ignored-env'])

          assert_not_nil importer.changes['ignored']
          assert_not_nil importer.changes['ignored']['ignored-env']
        end
      end
    end

    describe '#changes_for_environment' do
      test 'it calls for new, updated, obsolete and ignored classes' do
        environment_name = 'foreman-testing'
        changes = { 'new' => {}, 'obsolete' => {}, 'updated' => {}, 'ignored' => {} }

        importer.expects(:updated_classes_for).with(environment_name).once.returns({})
        importer.expects(:new_classes_for).with(environment_name).once.returns({})
        importer.expects(:removed_classes_for).with(environment_name).once.returns({})
        importer.expects(:ignored_classes_for).with(environment_name).once.returns({})

        importer.changes_for_environment(environment_name, changes)
      end
    end

    describe '#ignored_classes_for' do
      test 'returns an array of classes' do
        environment = 'foreman-testing'
        importer_with_proxy_api.stubs(:ignored_classes).returns([Regexp.new(/^ignored-class$/)])
        assert_equal ['ignored-class'], importer_with_proxy_api.ignored_classes_for(environment)
      end

      context 'has ignored environments' do
        test 'it returns them' do
          importer.stubs(:ignored_environments).returns(['ignored-env'])

          assert_not_nil importer.changes['ignored']
          assert_not_nil importer.changes['ignored']['ignored-env']
        end
      end
    end

    describe '#changes_for_environment' do
      test 'it calls for new, updated, obsolete and ignored classes' do
        environment_name = 'foreman-testing'
        changes = { 'new' => {}, 'obsolete' => {}, 'updated' => {}, 'ignored' => {} }

        importer.expects(:updated_classes_for).with(environment_name).once.returns({})
        importer.expects(:new_classes_for).with(environment_name).once.returns({})
        importer.expects(:removed_classes_for).with(environment_name).once.returns({})
        importer.expects(:ignored_classes_for).with(environment_name).once.returns({})

        importer.changes_for_environment(environment_name, changes)
      end
    end

    describe '#ignored_boolean_environment_names?' do
      test 'is true when an environment name is resulting in "true"' do
        importer_with_proxy_api.stubs(:ignored_environments).returns([true, 'test', 'another'])
        assert importer_with_proxy_api.ignored_boolean_environment_names?
      end

      test 'is true when an environment name is resulting in "false"' do
        importer_with_proxy_api.stubs(:ignored_environments).returns([false, 'test'])
        assert importer_with_proxy_api.ignored_boolean_environment_names?
      end
    end

    test 'should return list of envs' do
      assert_kind_of Array, importer.db_environments
    end

    test 'should return list of actual puppet envs' do
      assert_kind_of Array, importer.actual_environments
    end

    test 'should return list of classes' do
      assert_kind_of ActiveRecord::Relation, importer.db_classes(importer.db_environments.first)
    end

    test 'should return list of actual puppet classes' do
      assert_kind_of Hash, importer.actual_classes(importer.actual_environments.first)
    end

    test 'should obey config/ignored_environments.yml' do
      as_admin do
        hostgroups(:inherited).destroy # needs to be deleted first, since it has ancestry
        Hostgroup.destroy_all # to satisfy FK contraints when deleting Environments
        Environment.destroy_all
      end

      importer.stubs(:ignored_environments).returns(['foreman-testing'])
      assert_not importer.actual_environments.include?('foreman-testing')
    end

    test 'should save parameter when importing with a different default_value' do
      env = FactoryBot.build(:environment)
      pc = FactoryBot.build(:puppetclass, environments: [env])
      lk = FactoryBot.build(:puppetclass_lookup_key, default_value: 'first', puppetclass: pc)

      updated = importer.send(:update_classes_in_foreman, env.name,
        { pc.name => { 'updated' => [lk.key] } })
      assert_not_nil updated
    end

    test 'should not override parameter when default_value is empty' do
      env = FactoryBot.create(:environment)
      pc = FactoryBot.create(:puppetclass, environments: [env])

      importer.send(:update_classes_in_foreman, env.name,
        { pc.name => { 'new' => { 'test_nil_param' => nil } } })
      lk = PuppetclassLookupKey.where(key: 'test_nil_param').first
      assert_not lk.override
      assert_not lk.required
    end

    test 'should change default_value when importing from 2 environments' do
      envs = FactoryBot.create_list(:environment, 2)
      pc = FactoryBot.create(:puppetclass, environments: envs)

      importer.send(:update_classes_in_foreman, envs.first.name,
        { pc.name => { 'new' => { '2_env_param' => 'first' } } })
      assert_equal 'first', PuppetclassLookupKey.where(key: '2_env_param').first.default_value

      importer.send(:update_classes_in_foreman, envs.last.name,
        { pc.name => { 'updated' => { '2_env_param' => 'last' } } })
      assert_equal 'last', PuppetclassLookupKey.where(key: '2_env_param').first.default_value
    end

    context '#update_classes_in_foreman removes parameters' do
      let(:environments) { FactoryBot.create_list(:environment, 2) }
      let(:puppetclass) { FactoryBot.create(:puppetclass, environments: environments) }

      test 'from one environment' do
        lks = FactoryBot.create_list(:puppetclass_lookup_key, 2, puppetclass: puppetclass)
        importer.send(:update_classes_in_foreman, environments.first.name,
          { puppetclass.name => { 'obsolete' => [lks.first.key] } })
        assert_equal [environments.last], lks.first.environments
        assert_equal environments.to_a.sort, lks.last.environments.to_a.sort
      end

      test 'when overridden' do
        lks = FactoryBot.create_list(:puppetclass_lookup_key, 2, :with_override, puppetclass: puppetclass)
        importer.send(:update_classes_in_foreman, environments.first.name,
          { puppetclass.name => { 'obsolete' => [lks.first.key] } })
        assert_equal [environments.last], lks.first.environments
        assert_equal environments.to_a.sort, lks.last.environments.sort
      end

      test 'deletes the key from all environments' do
        lks = FactoryBot.create_list(:puppetclass_lookup_key, 2, :with_override, puppetclass: puppetclass)
        lval = lks.first.lookup_values.first
        importer.send(:update_classes_in_foreman, environments.first.name,
          { puppetclass.name => { 'obsolete' => [lks.first.key] } })
        importer.send(:update_classes_in_foreman, environments.last.name,
          { puppetclass.name => { 'obsolete' => [lks.first.key] } })
        assert_not PuppetclassLookupKey.find_by(id: lks.first.id)
        assert_not LookupValue.find_by(id: lval.id)
        assert_equal environments.to_a.sort, lks.last.environments.to_a.sort
      end
    end

    test 'should detect correct environments for import' do
      org_a = FactoryBot.create(:organization, name: 'OrgA')
      loc_a = FactoryBot.create(:location, name: 'LocA')
      org_b = FactoryBot.create(:organization, name: 'OrgB')
      loc_b = FactoryBot.create(:location, name: 'LocB')
      b_role = roles(:manager).clone name: 'b_role'
      b_role.add_permissions! %i[destroy_external_parameters edit_external_parameters create_external_parameters view_external_parameters
                                 import_puppetclasses view_environments import_environments create_environments]
      a_user = FactoryBot.create(:user, organizations: [org_a], locations: [loc_a], roles: [roles(:manager)], login: 'a_user')
      b_user = FactoryBot.create(:user, organizations: [org_b], locations: [loc_b], roles: [b_role], login: 'b_user')
      proxy = FactoryBot.build(:puppet_smart_proxy, organizations: [org_a, org_b], locations: [loc_a, loc_b])
      importer = PuppetClassImporter.new(url: proxy.url)
      FactoryBot.create(:environment, name: 'env_a', organizations: [org_a], locations: [loc_a])
      ProxyAPI::Puppet.any_instance.stubs(:environments).returns(%w[env_a b_env_new])
      User.current = b_user
      changes = importer.changes

      assert changes['new']['b_env_new']
      assert_not changes['new']['env_a']
      assert_not changes['updated']['env_a']

      changes['new']['b_env_new'] = changes['new']['b_env_new'].to_json

      importer.obsolete_and_new(changes)
      assert Environment.find_by(name: 'b_env_new')
      User.current = a_user
      assert_not Environment.find_by(name: 'b_env_new')
    end

    test 'should tax create audits correctly' do
      env = FactoryBot.create(:environment)
      klass_changes = { 'apache::new_nicecls' => {} }
      importer.obsolete_and_new('new' => { env.name => klass_changes.to_json })
      pc = Puppetclass.find_by(name: 'apache::new_nicecls')
      assert pc && pc.persisted?
      assert_equal 1, pc.audits.count
      audit = pc.audits.first
      assert_equal env.location_ids, audit.location_ids.sort
      assert_equal env.organization_ids, audit.organization_ids.sort
    end

    private

    def mocked_classes
      pcs = [{
        'apache::service' => {
          'name' => 'service',
          'params' => { 'port' => '80', 'version' => '2.0' },
          'module' => 'apache',
        },
      }]
      pcs.map { |k| [k.keys.first, Foreman::ImporterPuppetclass.new(k.values.first)] }.to_h
    end
  end
end
