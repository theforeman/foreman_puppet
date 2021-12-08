require 'test_puppet_helper'

module ForemanPuppet
  class HostPuppetFacetTest < ActiveSupport::TestCase
    let(:environment) { FactoryBot.create(:environment) }
    let(:diff_environment) { FactoryBot.create(:environment) }
    let(:puppetclass_both) { FactoryBot.create(:puppetclass, environments: [environment, diff_environment]) }
    let(:config_group) { FactoryBot.create(:config_group, :with_puppetclass, class_environments: [environment]) }
    let(:config_group_diff_env) { FactoryBot.create(:config_group, :with_puppetclass, class_environments: [diff_environment]) }

    describe '.populate_fields_from_facts' do
      test 'populate environment without any puppet info' do
        h = FactoryBot.create(:host)
        parser = stub(environment: environment)
        HostPuppetFacet.populate_fields_from_facts(h, parser, 'puppet', FactoryBot.create(:puppet_smart_proxy))
        assert_equal environment, h.puppet.environment
      end

      test 'changes puppet environment when setting says to do so' do
        Setting[:update_environment_from_facts] = true
        h = FactoryBot.create(:host, :with_puppet_enc)
        parser = stub(environment: environment)
        HostPuppetFacet.populate_fields_from_facts(h, parser, 'puppet', FactoryBot.create(:puppet_smart_proxy))
        assert_equal environment, h.puppet.environment
      end

      test 'keep puppet environment when parser has empty environment' do
        Setting[:update_environment_from_facts] = true
        h = FactoryBot.create(:host, :with_puppet_enc)
        parser = stub(environment: nil)
        HostPuppetFacet.populate_fields_from_facts(h, parser, 'puppet', FactoryBot.create(:puppet_smart_proxy))
        assert_not_nil h.puppet.environment
      end

      test 'do not update puppet environment when setting says not to' do
        Setting[:update_environment_from_facts] = false
        h = FactoryBot.create(:host, :with_puppet_enc)
        parser = stub(environment: environment)
        HostPuppetFacet.populate_fields_from_facts(h, parser, 'puppet', FactoryBot.create(:puppet_smart_proxy))
        assert_not_equal environment, h.puppet.environment
      end
    end

    describe '#classes_in_groups' do
      test 'classes_in_groups should return the puppetclasses of a config group only if it is in host environment' do
        host = FactoryBot.create(:host, :with_puppet_enc,
          location: taxonomies(:location1),
          organization: taxonomies(:organization1),
          environment: environment,
          config_groups: [config_group, config_group_diff_env])
        group_classes = host.puppet.classes_in_groups
        assert_equal config_group.puppetclasses.pluck(:id).sort, group_classes.map(&:id).sort
      end
    end

    describe '#all_puppetclasses' do
      test 'should return all classes for environment only' do
        host = FactoryBot.create(:host, :with_puppet_enc,
          location: taxonomies(:location1),
          organization: taxonomies(:organization1),
          environment: environment,
          config_groups: [config_group, config_group_diff_env],
          puppetclasses: [puppetclass_both])
        all_classes = host.puppet.classes
        # four classes in config groups plus one manually added
        assert_equal 2, all_classes.count
        assert_equal [puppetclass_both.id, config_group.puppetclass_ids.first].sort, all_classes.map(&:id).sort
        assert_equal all_classes, host.puppet.all_puppetclasses
      end
    end

    describe '#parent_classes' do
      test 'should return parent_classes if host has hostgroup and environment are the same' do
        hostgroup        = FactoryBot.create(:hostgroup, :with_puppet_enc, :with_puppetclass)
        host             = FactoryBot.create(:host, :with_puppet_enc, hostgroup: hostgroup, environment: hostgroup.puppet.environment)
        assert host.hostgroup
        assert_not_empty host.puppet.parent_classes
        assert_equal host.puppet.parent_classes, host.hostgroup.puppet.classes
      end

      test 'should not return parent classes that do not match environment' do
        # one class in the right env, one in a different env
        pclass2 = FactoryBot.create(:puppetclass, environments: [diff_environment])
        hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, puppetclasses: [puppetclass_both, pclass2], environment: environment)
        host = FactoryBot.create(:host, :with_puppet_enc, hostgroup: hostgroup, environment: diff_environment)
        assert host.hostgroup
        assert_not_empty host.puppet.parent_classes
        assert_not_equal host.puppet.environment, host.hostgroup.puppet.environment
        assert_not_equal host.puppet.parent_classes, host.hostgroup.puppet.classes
      end

      test 'should return empty array if host does not have hostgroup' do
        host = FactoryBot.create(:host, :with_puppet_enc)
        assert_nil host.hostgroup
        assert_empty host.puppet.parent_classes
      end
    end

    describe '#parent_config_groups' do
      test 'should return parent config_groups if host has hostgroup' do
        hostgroup        = FactoryBot.create(:hostgroup, :with_puppet_enc, :with_config_group)
        host             = FactoryBot.create(:host, :with_puppet_enc, hostgroup: hostgroup, environment: hostgroup.puppet.environment)
        assert host.hostgroup
        assert_equal host.puppet.parent_config_groups, host.hostgroup.puppet.config_groups
      end

      test 'should return empty array if host has no hostgroup' do
        host = FactoryBot.create(:host, :with_puppet_enc)
        assert_not host.hostgroup
        assert_empty host.puppet.parent_config_groups
      end

      test 'should return empty array if hostgroup do not have puppet data' do
        hostgroup = FactoryBot.create(:hostgroup)
        host = FactoryBot.create(:host, :with_puppet_enc, hostgroup: hostgroup)
        assert_empty host.puppet.parent_config_groups
      end
    end

    describe '#individual_puppetclasses' do
      test 'individual puppetclasses added to host (that can be removed) does not include classes that are included by config group' do
        host   = FactoryBot.create(:host, :with_puppet_enc, :with_config_group)
        pclass = FactoryBot.create(:puppetclass, environments: [host.puppet.environment])
        host.puppet.puppetclasses << pclass
        # not sure why, but .classes and .puppetclasses don't return the same thing here...
        assert_equal (host.puppet.config_groups.first.classes + [pclass]).map(&:name).sort, host.puppet.classes.map(&:name).sort
        assert_equal [pclass.name], host.puppet.individual_puppetclasses.map(&:name)
      end
    end

    describe '#available_puppetclasses' do
      test 'available_puppetclasses should return all if no environment' do
        host = FactoryBot.create(:host, :with_puppet_enc)
        host.puppet.update(environment_id: nil)
        assert_equal ForemanPuppet::Puppetclass.where(nil), host.puppet.available_puppetclasses
      end

      test 'available_puppetclasses should return environment-specific classes' do
        puppetclass_both
        host = FactoryBot.create(:host, :with_puppet_enc)
        assert_not_equal ForemanPuppet::Puppetclass.where(nil), host.puppet.available_puppetclasses
        assert_equal host.puppet.environment.puppetclasses.sort, host.puppet.available_puppetclasses.sort
      end

      test 'available_puppetclasses should return environment-specific classes (and that are NOT already inherited by parent)' do
        puppetclass_both
        hostgroup        = FactoryBot.create(:hostgroup, :with_puppet_enc, :with_puppetclass, environment: environment)
        host             = FactoryBot.create(:host, :with_puppet_enc, hostgroup: hostgroup, environment: environment)
        assert_not_equal ForemanPuppet::Puppetclass.where(nil), host.puppet.available_puppetclasses
        assert_not_equal host.puppet.environment.puppetclasses.sort, host.puppet.available_puppetclasses.sort
        assert_equal (host.puppet.environment.puppetclasses - host.puppet.parent_classes).sort, host.puppet.available_puppetclasses.sort
      end
    end
  end
end
