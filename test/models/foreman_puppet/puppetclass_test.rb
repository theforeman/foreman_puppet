require 'test_puppet_helper'

module ForemanPuppet
  class PuppetclassTest < ActiveSupport::TestCase
    setup do
      User.current = users(:admin)
    end

    should validate_presence_of(:name)
    should validate_uniqueness_of(:name)

    test 'name strips leading and trailing white spaces' do
      puppet_class = Puppetclass.new name: '   testclass   '
      assert puppet_class.save
      assert_not puppet_class.name.ends_with?(' ')
      assert_not puppet_class.name.starts_with?(' ')
    end

    test 'looking for a nonexistent host returns no puppetclasses' do
      assert_empty Puppetclass.search_for('host = imaginaryhost.nodomain.what')
    end

    test 'Puppetclass singularize from custom inflection' do
      assert_equal 'Puppetclass', 'Puppetclass'.singularize
      assert_equal 'Puppetclass', 'Puppetclasses'.singularize
      assert_equal 'puppetclass', 'puppetclass'.singularize
      assert_equal 'puppetclass', 'puppetclasses'.singularize
    end

    test 'Puppetclass classify from custom inflection' do
      assert_equal 'Puppetclass', 'Puppetclass'.classify
      assert_equal 'Puppetclass', 'Puppetclasses'.classify
      assert_equal 'Puppetclass', 'puppetclass'.classify
      assert_equal 'Puppetclass', 'puppetclasses'.classify
    end

    context 'all_hostgroups should show hostgroups and their descendants' do
      setup do
        @class = FactoryBot.create(:puppetclass)
        @hg1 = FactoryBot.create(:hostgroup, :with_puppet_enc)
        @hg2 = FactoryBot.create(:hostgroup, :with_puppet_enc, parent_id: @hg1.id)
        @hg3 = FactoryBot.create(:hostgroup, :with_puppet_enc, parent_id: @hg2.id)
        @config_group = FactoryBot.create(:config_group)
        @hg1.puppet.config_groups << @config_group
      end

      it 'when added directly' do
        assert_difference('@class.all_hostgroups.count', 3) do
          @class.hostgroup_puppet_facets << @hg1.puppet
        end
      end

      it 'when added directly and called without descendants' do
        assert_difference(-> { @class.all_hostgroups(with_descendants: false).count }, 1) do
          @class.hostgroup_puppet_facets << @hg1.puppet
        end
      end

      it 'when added via config group' do
        assert_difference('@class.all_hostgroups.count', 3) do
          @class.config_groups << @config_group
        end
      end

      it 'when added directly and called without descendants' do
        assert_difference(-> { @class.all_hostgroups(with_descendants: false).count }, 1) do
          @class.config_groups << @config_group
        end
      end
    end

    context 'host counting' do
      setup do
        @env = FactoryBot.create(:environment)
        @class = FactoryBot.create(:puppetclass)
        @parent_hg = FactoryBot.create(:hostgroup, :with_puppet_enc)
        @hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, parent: @parent_hg)
        @config_group = FactoryBot.create(:config_group, puppetclasses: [@class])
        @host = FactoryBot.create(:host, :with_puppet_enc, environment: @env)
      end

      test 'correctly counts direct hosts' do
        @host.puppet.puppetclasses << @class
        assert_equal 1, @class.hosts_count
      end

      test 'correctly counts hosts via config group' do
        @host.puppet.config_groups << @config_group
        assert_equal 1, @class.hosts_count
      end

      test 'correctly counts hosts via hostgroup' do
        @hostgroup.puppet.puppetclasses << @class
        @host.update(hostgroup_id: @hostgroup.id)
        assert_equal 1, @class.hosts_count
      end

      test 'correctly counts hosts via parent hostgroup' do
        @host.update(hostgroup_id: @hostgroup.id)
        @parent_hg.puppet.puppetclasses << @class
        assert_equal 1, @class.hosts_count
      end

      test 'correctly counts hosts via hostgroup config group' do
        @host.update(hostgroup_id: @hostgroup.id)
        @hostgroup.puppet.config_groups << @config_group
        assert_equal 1, @class.hosts_count
      end

      test 'correctly counts hosts via parent hostgroup config group' do
        @host.update(hostgroup_id: @hostgroup.id)
        @parent_hg.puppet.config_groups << @config_group
        assert_equal 1, @class.hosts_count
      end

      test 'only count host once even if it has multiple connections to puppetclass' do
        @host.puppet.puppetclasses << @class
        @host.puppet.config_groups << @config_group
        @hostgroup.puppet.puppetclasses << @class
        @hostgroup.puppet.config_groups << @config_group
        @parent_hg.puppet.puppetclasses << @class
        @parent_hg.puppet.config_groups << @config_group
        @host.update(hostgroup_id: @hostgroup.id)
        assert_equal 1, @class.hosts_count
      end
    end

    context 'search in puppetclasses' do
      setup do
        @class = FactoryBot.create(:puppetclass)
        @hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, puppetclasses: [@class])
        @config_group = FactoryBot.create(:config_group, puppetclasses: [@class])
      end

      test 'search for puppetclass by hostgroup' do
        assert_includes(Puppetclass.search_for("hostgroup = #{@hostgroup.to_label}"), @class)
      end

      test 'search for puppetclass by config_group' do
        assert_includes(Puppetclass.search_for("config_group = #{@config_group.to_label}"), @class)
      end
    end
  end
end
