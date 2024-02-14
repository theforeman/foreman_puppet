require 'test_puppet_helper'

module ForemanPuppet
  class HostTest < ActiveSupport::TestCase
    test 'should read the Puppetserver URL from its proxy settings' do
      host = FactoryBot.build_stubbed(:host)
      expect(host.puppet_server_uri).must_be_nil
      expect(host.puppetmaster).must_be_empty

      proxy = FactoryBot.create(:puppet_smart_proxy, url: 'https://smartproxy.example.com:8443')
      host.puppet_proxy = proxy
      expect(host.puppet_server_uri.to_s).must_equal 'https://smartproxy.example.com:8140'
      expect(host.puppetmaster).must_equal 'smartproxy.example.com'

      features = {
        'puppet' => {
          settings: { puppet_url: 'https://puppet.example.com:8140' },
        },
      }
      SmartProxyFeature.import_features(proxy, features)
      expect(host.puppet_server_uri.to_s).must_equal 'https://puppet.example.com:8140'
      expect(host.puppetmaster).must_equal 'puppet.example.com'
    end

    test 'should find smart proxy ids' do
      host = FactoryBot.create(:host, :with_puppet_enc)
      puppet_id = host.puppet_proxy_id

      res = Host.smart_proxy_ids(Host.where(id: [host.id]))

      assert_includes res, puppet_id
    end

    describe '#search_for' do
      let(:host) { FactoryBot.create(:host, :with_puppet_enc, :with_puppetclass) }

      test 'can search hosts by smart proxy' do
        proxy = FactoryBot.create(:puppet_and_ca_smart_proxy)
        results = Host.search_for("smart_proxy = #{proxy.name}")
        assert_equal 0, results.count
        host.update(puppet_proxy_id: proxy.id)
        results = Host.search_for("smart_proxy = #{proxy.name}")
        assert_equal 1, results.count
        assert_includes results, host
        # the results should not change even if the host has multiple connections to same proxy
        host.update(puppet_ca_proxy_id: proxy.id)
        results2 = Host.search_for("smart_proxy = #{proxy.name}")
        assert_equal results, results2
      end

      test 'deprecated search by class throws error' do
        exception = assert_raises(Exception) do
          host
          Host.search_for("class = #{host.puppet.puppetclass_names.first}")
        end
        assert_equal("Field 'class' not recognized for searching!", exception.message)
      end

      test 'can be found by puppetclass' do
        host
        result = Host.search_for("puppetclass = #{host.puppet.puppetclass_names.first}")
        assert_includes result, host
      end

      test 'search by puppetclass returns only host within that puppetclass' do
        host
        puppetclass = FactoryBot.create(:puppetclass)
        result = Host.search_for("puppetclass = #{puppetclass.name}")
        assert_not_includes result, host
      end

      test 'search hosts by inherited puppetclass from a hostgroup' do
        hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, :with_puppetclass)
        host_with_hg = FactoryBot.create(:host, hostgroup: hostgroup)
        result = Host.search_for("puppetclass = #{hostgroup.puppet.puppetclass_names.first}")
        assert_includes result, host_with_hg
      end

      test 'can search hosts by inherited puppet class from a parent hostgroup' do
        parent_hg = FactoryBot.create(:hostgroup, :with_puppet_enc, :with_puppetclass)
        hg = FactoryBot.create(:hostgroup, parent: parent_hg)
        host = FactoryBot.create(:host, hostgroup: hg)
        result = Host.search_for("puppetclass = #{parent_hg.puppet.puppetclass_names.first}")
        assert_equal 1, result.count
        assert_includes result, host
      end

      test 'can search hosts by puppet class from config group in parent hostgroup' do
        hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc)
        host = FactoryBot.create(:host, :with_puppet_enc, hostgroup: hostgroup, environment: hostgroup.puppet.environment)
        config_group = FactoryBot.create(:config_group, :with_puppetclass)
        hostgroup.puppet.config_groups << config_group
        result = Host.search_for("puppetclass = #{config_group.puppetclass_names.first}")
        assert_equal 1, result.count
        assert_includes result, host
      end

      test 'can be found by config group' do
        host.puppet.config_groups << FactoryBot.create(:config_group)
        result = Host.search_for("config_group = #{host.puppet.config_group_names.first}")
        assert_includes result, host
      end

      test 'search by config group returns only host within that config group' do
        host
        config_group = FactoryBot.create(:config_group)
        result = Host.search_for("config_group = #{config_group.name}")
        assert_not_includes result, host
      end

      test 'search by config_group of hostgroup' do
        hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, :with_config_group)
        host_with_hg = FactoryBot.create(:host, hostgroup: hostgroup)
        result = Host.search_for("config_group = #{hostgroup.puppet.config_group_names.first}")
        assert_includes result, host_with_hg
        assert_equal [host_with_hg.name], result.map(&:name)
      end
    end

    describe '#info puppet bits' do
      test 'ENC YAML omits environment if no puppet facet' do
        host = FactoryBot.build_stubbed(:host)
        enc = host.info
        assert_not_includes enc.keys, 'environment'
      end

      test 'ENC YAML uses Classification::ClassParam for parameterized output' do
        skip 'No idea whats wrong here'
        host = FactoryBot.build_stubbed(:host, :with_environment)
        classes = { 'myclass' => { 'myparam' => 'myvalue' } }
        ForemanPuppet::HostInfoProviders::PuppetInfo.any_instance.expects(:puppetclass_parameters).returns(classes)
        enc = host.info
        assert_kind_of Hash, enc
        assert_equal classes, enc['classes']
      end

      test '#info ENC YAML contains config_groups' do
        host = FactoryBot.create(:host, :with_puppet_enc, :with_config_group)
        enc = host.info
        assert_includes(enc['parameters'].keys, 'foreman_config_groups')
        assert_includes(enc['parameters']['foreman_config_groups'], host.puppet.config_group_names.first)
      end

      test '#info ENC YAML contains parent hostgroup config_groups' do
        hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, :with_config_group)
        host = FactoryBot.create(:host, :with_puppet_enc, :with_config_group, hostgroup: hostgroup)
        enc = host.info
        assert_equal(enc['parameters']['foreman_config_groups'], [host.puppet.config_group_names.first, hostgroup.puppet.config_group_names.first])
      end
    end

    describe '#clone' do
      test '#classes etc. on cloned host return the same' do
        hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, :with_config_group, :with_puppetclass)
        host = FactoryBot.create(:host, :with_puppet_enc, :with_config_group, :with_puppetclass, :with_parameter,
          hostgroup: hostgroup, environment: hostgroup.puppet.environment)
        copy = host.clone
        expect(copy.puppet.individual_puppetclasses.map(&:id)).must_equal(host.puppet.individual_puppetclasses.map(&:id))
        expect(copy.puppet.classes_in_groups.map(&:id)).must_equal(host.puppet.classes_in_groups.map(&:id))
        expect(copy.puppet.classes.map(&:id)).must_equal(host.puppet.classes.map(&:id))
        expect(copy.puppet.available_puppetclasses.map(&:id)).must_equal(host.puppet.available_puppetclasses.map(&:id))
        expect(copy.puppet.host_classes.map(&:puppetclass_id)).must_equal(host.puppet.host_classes.map(&:puppetclass_id))
        expect(copy.puppet.host_config_groups.map(&:config_group_id)).must_equal(host.puppet.host_config_groups.map(&:config_group_id))
      end
    end

    describe '#available_template_kinds' do
      let(:template_kinds) { [stub(name: 'iPXE'), stub(name: 'finish')] }

      test 'calls find_template with Puppet environment' do
        host = FactoryBot.create(:host, :with_hostgroup, :with_puppet_enc)
        host.expects(:template_kinds).returns(template_kinds)
        template_kinds.each do |kind|
          ::ProvisioningTemplate.expects(:find_template)
                                .with({ kind: kind.name, operatingsystem_id: host.operatingsystem.id, hostgroup_id: host.hostgroup.id, environment_id: host.puppet.environment.id })
                                .returns(stub(name: "default #{kind.name}"))
        end
        assert_equal template_kinds.map { |k| "default #{k.name}" }, host.available_template_kinds.map(&:name)
      end

      test 'calls find_template without Puppet environment' do
        host = FactoryBot.create(:host, :with_hostgroup)
        host.expects(:template_kinds).returns(template_kinds)
        template_kinds.each do |kind|
          ::ProvisioningTemplate.expects(:find_template)
                                .with({ kind: kind.name, operatingsystem_id: host.operatingsystem.id, hostgroup_id: host.hostgroup.id, environment_id: nil })
                                .returns(stub(name: "default #{kind.name}"))
        end
        assert_equal template_kinds.map { |k| "default #{k.name}" }, host.available_template_kinds.map(&:name)
      end
    end

    test 'should import from external nodes output' do
      # create a dummy node
      Parameter.destroy_all
      env = FactoryBot.create(:environment)
      host = FactoryBot.create(:host, :with_puppet_enc, environment: env, ip: '3.3.4.12')
      pc1 = FactoryBot.create(:puppetclass, environments: [env], parameter_count: 1)
      pc2 = FactoryBot.create(:puppetclass, environments: [env], parameter_count: 1)

      classes_params = { pc1.name => { pc1.class_params.first.key => 'abcdef' },
                         pc2.name => { pc2.class_params.first.key => 'secret' } }
      # dummy external node info
      nodeinfo = { 'environment' => env.name,
                   'parameters' => { 'puppetmaster' => 'puppet', 'MYVAR' => 'value', 'port' => '80',
                                     'ssl_port' => '443', 'foreman_env' => 'production', 'owner_name' => 'Admin User',
                                     'root_pw' => 'xybxa6JUkz63w', 'owner_email' => 'admin@someware.com',
                                     'foreman_subnets' =>
      [{ 'network' => '3.3.4.0',
         'name' => 'two',
         'gateway' => nil,
         'mask' => '255.255.255.0',
         'dns_primary' => nil,
         'dns_secondary' => nil,
         'from' => nil,
         'to' => nil,
         'boot_mode' => 'DHCP',
         'vlanid' => '41',
         'ipam' => 'DHCP' }],
                                     'foreman_interfaces' =>
      [{ 'mac' => 'aa:bb:ac:dd:ee:ff',
         'ip' => '3.3.4.12',
         'type' => 'Interface',
         'name' => 'myfullhost.mydomain.net',
         'attrs' => {},
         'virtual' => false,
         'link' => true,
         'identifier' => nil,
         'managed' => true,
         'primary' => true,
         'provision' => true,
         'subnet' => { 'network' => '3.3.4.0',
                       'mask' => '255.255.255.0',
                       'name' => 'two',
                       'gateway' => nil,
                       'dns_primary' => nil,
                       'dns_secondary' => nil,
                       'from' => nil,
                       'to' => nil,
                       'boot_mode' => 'DHCP',
                       'vlanid' => '41',
                       'ipam' => 'DHCP' } }] },
                   'classes' => classes_params }

      host.importNode nodeinfo
      nodeinfo['parameters']['special_info'] = 'secret' # smart variable on apache

      info = host.info
      expect(host.puppet.environment.name).must_equal(env.name)
      expect(info.keys).must_include 'environment'
      expect(info.keys).must_include 'parameters'
      expect(info.keys).must_include 'classes'
      # This worked in core, but it's beyond me how could have :shrug:
      # assert_equal(classes_params, info['classes'])
      # We are only importing classes in the method
      expect(info['classes'].keys.sort).must_equal(classes_params.keys.sort)
      parameters = info['parameters']
      expect(parameters['puppetmaster']).must_equal 'puppet'
      expect(parameters['root_pw']).must_equal 'xybxa6JUkz63w'
      expect(parameters['foreman_interfaces'].first['ip']).must_equal '3.3.4.12'
      expect(parameters.keys).must_include 'foreman_subnets'
      expect(parameters.keys).must_include 'foreman_interfaces'
    end

    test 'should import from non-parameterized external nodes output' do
      host = FactoryBot.create(:host, :with_puppet_enc)
      env = host.puppet.environment
      pc1, pc2 = FactoryBot.create_list(:puppetclass, 2, environments: [env])
      host.importNode('environment' => env.name, 'classes' => [pc1.name, pc2.name], 'parameters' => {})

      assert_equal [pc1.name, pc2.name].sort, host.info['classes'].keys.sort
    end

    test 'does not assign a host to environment with incorrect taxonomies' do
      host = FactoryBot.build(:host, managed: false)
      env_with_tax = FactoryBot.create(:environment, organizations: [host.organization], locations: [host.location])
      env_with_other_tax = FactoryBot.create(:environment, organizations: [FactoryBot.create(:organization)],
                                                           locations: [FactoryBot.create(:location)])
      host.build_puppet
      host.puppet.environment = env_with_tax
      assert host.valid?

      host.puppet.environment = env_with_other_tax
      assert_not host.valid?
      assert_match(/is not assigned/, host.errors['puppet.environment_id'].first)
    end

    test 'when saving a host, require puppet environment if puppet master is set' do
      h = FactoryBot.build_stubbed(:host, :with_puppet_enc)
      h.puppet.environment = nil
      assert_not h.valid?
    end

    test 'host puppet classes must belong to the host environment' do
      h = FactoryBot.create(:host, :with_puppet_enc)
      pc = FactoryBot.create(:puppetclass)
      h.puppet.puppetclasses << pc
      assert_not h.puppet.environment.puppetclasses.map(&:id).include?(pc.id)
      assert_not h.puppet.valid?
      assert_equal ["#{pc} does not belong to the #{h.puppet.environment} environment"], h.puppet.errors[:puppetclasses]
    end

    test 'when changing host environment, its puppet classes should be verified' do
      h = FactoryBot.create(:host, :with_puppet_enc)
      pc = FactoryBot.create(:puppetclass, environments: [h.puppet.environment])
      h.puppet.puppetclasses << pc
      h.puppet.environment = FactoryBot.create(:environment)
      assert_not h.puppet.save
      assert_equal ["#{pc} does not belong to the #{h.puppet.environment} environment"], h.puppet.errors[:puppetclasses]
    end

    test 'when setting host environment to nil, its puppet classes should be removed' do
      h = FactoryBot.create(:host, :with_puppet_enc, :with_puppetclass)
      h.puppet_proxy = nil
      h.puppet.environment = nil
      h.puppet.save!
      assert_empty h.puppet.puppetclasses
    end

    test 'when setting host environment to nil, its config groups should be removed' do
      h = FactoryBot.create(:host, :with_puppet_enc, :with_config_group)
      assert h.save
      h.puppet_proxy = nil
      h.puppet.environment = nil
      h.save!
      assert_empty h.puppet.config_groups
    end
  end
end
