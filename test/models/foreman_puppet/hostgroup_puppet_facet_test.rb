require 'test_puppet_helper'

module ForemanPuppet
  class HostgroupPuppetFacetTest < ActiveSupport::TestCase
    let(:environment) { FactoryBot.create(:environment) }
    let(:hostgroup) { FactoryBot.create(:hostgroup, :with_puppet_enc, :with_puppetclass, :with_config_group, environment: environment) }
    let(:child_hostgroup) do
      FactoryBot.create(:hostgroup,
        :with_puppet_enc,
        :with_puppetclass,
        :with_config_group,
        :with_parent,
        parent: hostgroup, environment: environment)
    end
    let(:standalone_puppetclass) { FactoryBot.create(:puppetclass) }

    test 'should inherit parent classes' do
      child_all_classes = child_hostgroup.puppet.classes
      hostgroup.puppet.classes do |puppet_class|
        assert_include puppet_class, child_all_classes
      end
    end

    test 'changing environment should preserve puppetclasses' do
      skip 'Something fishy on env update, try once extracted' unless ForemanPuppet.extracted_from_core?
      new_environment = FactoryBot.create(:environment)
      old_puppetclass_ids = hostgroup.puppet.puppetclass_ids

      hostgroup.puppet.update!(environment: new_environment)
      hostgroup.reload

      assert_equal new_environment, hostgroup.puppet.environment
      assert_equal old_puppetclass_ids.sort, hostgroup.puppet.puppetclass_ids.sort
    end

    test 'should return all classes for environment only' do
      config_group1 = hostgroup.puppet.config_groups.first
      config_group1.puppetclasses << FactoryBot.create(:puppetclass, environments: [environment]) unless config_group1.puppetclasses.any?
      config_group2 = FactoryBot.create(:config_group, :with_puppetclass, class_environments: [FactoryBot.create(:environment)])
      hostgroup.puppet.config_groups << config_group2

      all_classes = hostgroup.puppet.classes
      env_puppetclasses = hostgroup.puppet.puppetclasses.to_a + hostgroup.puppet.config_groups.first.puppetclasses.to_a
      assert_equal(2, all_classes.count)
      assert_equal env_puppetclasses.map(&:id).sort, all_classes.map(&:id).sort
    end

    describe '#available_puppetclasses' do
      setup do
        standalone_puppetclass
      end

      test 'should return all if no environment' do
        hostgroup.puppet.update(environment_id: nil)
        assert_equal ForemanPuppet::Puppetclass.all, hostgroup.puppet.available_puppetclasses
      end

      test 'should return environment-specific classes' do
        FactoryBot.create(:puppetclass, environments: [environment])
        assert_not_include hostgroup.puppet.available_puppetclasses, standalone_puppetclass
        assert_equal environment.puppetclasses.sort, hostgroup.puppet.available_puppetclasses.sort
      end

      test 'should return environment-specific classes (and that are NOT already inherited by parent)' do
        assert_not_include child_hostgroup.puppet.available_puppetclasses, standalone_puppetclass
        assert_not_equal environment.puppetclasses.sort, child_hostgroup.puppet.available_puppetclasses.sort
        assert_equal (environment.puppetclasses - child_hostgroup.puppet.parent_classes).sort, child_hostgroup.puppet.available_puppetclasses.sort
      end
    end

    describe '#individual_puppetclasses' do
      context 'updating environment' do
        test 'should return correctly, when updating environment for a new (or cloned) hostgroup' do
          # ?????
          cloned = Hostgroup.new
          cloned.build_puppet.puppetclasses = hostgroup.puppet.puppetclasses
          assert_equal cloned.puppet.individual_puppetclasses, hostgroup.puppet.individual_puppetclasses
        end
      end

      context 'has NOT set an environment' do
        test 'returns all classes' do
          assert_includes hostgroup.puppet.individual_puppetclasses.all, hostgroup.puppet.puppetclasses.first
        end
      end

      context 'has an environment set' do
        setup do
          hostgroup.puppet.puppetclasses << standalone_puppetclass
        end

        test 'returns classes regardless of environment by default' do
          assert_includes hostgroup.puppet.individual_puppetclasses, hostgroup.puppet.puppetclasses.first
          assert_includes hostgroup.puppet.individual_puppetclasses, standalone_puppetclass
        end
      end

      test 'puppetclasses added to hostgroup (that can be removed) does not include classes that are included by config group' do
        config_group = FactoryBot.create(:config_group, :with_puppetclass, class_environments: [environment])
        hostgroup.puppet.config_groups << config_group

        assert_includes hostgroup.puppet.all_puppetclasses, config_group.puppetclasses.first
        assert_not_includes hostgroup.puppet.individual_puppetclasses, config_group.puppetclasses.first
      end
    end

    describe '#classes_in_groups' do
      test 'should return the puppetclasses of a config group only if it is in hostgroup environment' do
        config_group1 = hostgroup.puppet.config_groups.first
        config_group1.puppetclasses << FactoryBot.create(:puppetclass, environments: [environment]) unless config_group1.puppetclasses.any?
        config_group2 = FactoryBot.create(:config_group, :with_puppetclass, class_environments: [FactoryBot.create(:environment)])
        hostgroup.puppet.config_groups << config_group2

        group_classes = hostgroup.puppet.classes_in_groups
        assert_equal 2, (config_group1.puppetclasses + config_group2.puppetclasses).uniq.count
        # but only 1 is in hostgroup environment.
        assert_equal 1, group_classes.count
        assert_equal config_group1.puppetclasses.pluck(:id).sort, group_classes.map(&:id).sort
      end
    end

    describe '#parent_classes' do
      test 'should return parent classes if hostgroup has parent and environment are the same' do
        assert_equal child_hostgroup.puppet.parent_classes, hostgroup.puppet.classes
      end

      test 'should not return parent classes that do not match environment' do
        new_environment = FactoryBot.create(:environment)
        new_pc = FactoryBot.create(:puppetclass, environments: [environment, new_environment])
        hostgroup.puppet.config_groups.first.puppetclasses << new_pc
        hostgroup.reload
        child_hostgroup.puppet.update(environment: new_environment)
        child_hostgroup.reload
        assert_not_empty child_hostgroup.puppet.parent_classes
        assert_not_equal child_hostgroup.puppet.parent_classes, hostgroup.puppet.classes
      end

      test 'should be empty if hostgroup does not have parent' do
        assert_empty hostgroup.puppet.parent_classes
      end
    end

    describe '#parent_config_groups' do
      test 'should return empty array if hostgroup does not has parent' do
        assert_empty hostgroup.puppet.parent_config_groups
      end

      test 'should return parent config_groups if hostgroup has parent - 2 levels' do
        assert child_hostgroup.parent
        assert_equal child_hostgroup.puppet.parent_config_groups, hostgroup.puppet.config_groups
      end

      test 'should return parent config_groups if hostgroup has parent  - 3 levels' do
        hg = FactoryBot.create(:hostgroup, name: 'third level', parent_id: child_hostgroup.id)
        hg.create_puppet
        groups = (hg.parent.puppet.config_groups + hg.parent.parent.puppet.config_groups).uniq.sort
        assert_equal groups, hg.puppet.parent_config_groups.sort
      end
    end

    describe 'Hostgroup#clone' do
      test 'should clone puppet classes' do
        cloned = hostgroup.clone('new_name')
        assert_equal hostgroup.puppet.hostgroup_classes.map(&:puppetclass_id), cloned.puppet.hostgroup_classes.map(&:puppetclass_id)
      end

      test '#classes etc. on cloned group return the same' do
        cloned = child_hostgroup.clone('cloned')
        cloned_puppet = cloned.puppet
        group_puppet = child_hostgroup.puppet
        assert_equal group_puppet.individual_puppetclasses.map(&:id), cloned_puppet.individual_puppetclasses.map(&:id)
        assert_equal group_puppet.classes_in_groups.map(&:id), cloned_puppet.classes_in_groups.map(&:id)
        assert_equal group_puppet.classes.map(&:id), cloned_puppet.classes.map(&:id)
        assert_equal group_puppet.available_puppetclasses.map(&:id), cloned_puppet.available_puppetclasses.map(&:id)
        assert_valid cloned
      end

      test 'without save makes no changes' do
        FactoryBot.create(:puppetclass_lookup_key, :with_override, path: "hostgroup\ncomment",
                                                                   puppetclass: hostgroup.puppet.puppetclasses.first,
                                                                   overrides: { hostgroup.lookup_value_matcher => 'test' })
        ActiveRecord::Base.any_instance.expects(:destroy).never
        ActiveRecord::Base.any_instance.expects(:save).never
        hostgroup.clone
      end

      test 'clone with config group should run validations once' do
        cloned = hostgroup.clone
        assert_not cloned.valid?
        assert_equal 1, cloned.errors[:name].size
      end

      test 'clone should clone config groups as well' do
        cg_ids = hostgroup.puppet.config_groups.pluck(:id)
        cloned = hostgroup.clone('new_name')
        assert_equal cg_ids.sort, cloned.puppet.config_groups.map(&:id).sort
      end
    end
  end
end
