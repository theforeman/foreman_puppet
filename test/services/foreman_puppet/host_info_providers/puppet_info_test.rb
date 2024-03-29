require 'test_puppet_helper'

module ForemanPuppet
  class PuppetInfoTest < ActiveSupport::TestCase
    let(:environment) { FactoryBot.create(:environment) }
    let(:puppetclass) { FactoryBot.create(:puppetclass, environments: [environment]) }
    let(:puppetclass_two) { FactoryBot.create(:puppetclass, environments: [environment]) }
    let(:key_lookup_path) { "fqdn\norganization,location\nhostgroup\nos" }
    let(:puppetclass_lookup_key) do
      FactoryBot.create(
        :puppetclass_lookup_key,
        puppetclass: puppetclass,
        default_value: 'secret',
        path: key_lookup_path
      )
    end

    def setup
      @host = FactoryBot.build(:host, :with_puppet_enc,
        location: taxonomies(:location1),
        organization: taxonomies(:organization1),
        operatingsystem: operatingsystems(:redhat),
        puppetclasses: [puppetclass],
        environment: environment)
      puppetclass_lookup_key
    end

    test 'enc_should_return_param_default_value' do
      enc = HostInfoProviders::PuppetInfo.new(@host).puppetclass_parameters
      assert_equal 'secret', enc[puppetclass.name][puppetclass_lookup_key.key]
    end

    test 'enc_should_return_updated_cluster_param' do
      assert_equal "fqdn\norganization,location\nhostgroup\nos", puppetclass_lookup_key.path
      assert_equal taxonomies(:location1), @host.location
      assert_equal taxonomies(:organization1), @host.organization

      value = as_admin do
        LookupValue.create! lookup_key_id: puppetclass_lookup_key.id,
          match: "organization=#{taxonomies(:organization1)},location=#{taxonomies(:location1)}",
          value: 'test',
          omit: false
      end
      enc = HostInfoProviders::PuppetInfo.new(@host).puppetclass_parameters

      assert_equal value.value, enc[puppetclass.name][puppetclass_lookup_key.key]
    end

    test '#enc should return hash of class to nil for classes without parameters' do
      env = FactoryBot.build(:environment)
      pc = FactoryBot.build(:puppetclass, environments: [env])
      assert_equal({ pc.name => nil }, get_classparam(env, pc).puppetclass_parameters)
    end

    test '#enc should not return class parameters where override is false' do
      pc = FactoryBot.create(:puppetclass, :with_parameters, environments: [environment])
      assert_not pc.class_params.first.override
      assert_equal({ pc.name => nil }, get_classparam(environment, pc).puppetclass_parameters)
    end

    test '#enc should return default value of class parameters without lookup_values' do
      pc = FactoryBot.create(:puppetclass, environments: [environment])
      lkey = FactoryBot.create(:puppetclass_lookup_key, puppetclass: pc, default_value: 'test')
      assert_equal({ pc.name => { lkey.key => lkey.default_value } }, get_classparam(environment, pc).puppetclass_parameters)
    end

    test '#enc should return override value of class parameters' do
      pc = FactoryBot.create(:puppetclass, :with_parameters, environments: [environment]).reload
      lkey = FactoryBot.create(:puppetclass_lookup_key, puppetclass: pc, path: 'comment', overrides: { 'comment=override' => 'overridden value' })
      classparam = get_classparam(environment, pc)
      host = classparam.send(:host)
      host.expects(:comment).returns('override')
      assert_equal({ pc.name => { lkey.key => 'overridden value' } }, classparam.puppetclass_parameters)
    end

    test "#values_hash should contain element's name and managed element for puppet key" do
      lkey = FactoryBot.create(:puppetclass_lookup_key, :with_override, puppetclass: puppetclass)
      host = FactoryBot.build_stubbed(:host, :with_puppet_enc, environment: environment, puppetclasses: [puppetclass])
      Classification::MatchesGenerator.any_instance.expects(:attr_to_value).with('comment').returns('override')

      expected = {
        lkey.id => {
          lkey.key => {
            value: 'overridden value',
            element: 'comment',
            element_name: 'override',
            managed: false,
          },
        },
      }
      assert_equal(expected, Classification::ValuesHashQuery.values_hash(host, LookupKey.where(id: [lkey])).raw)

      Classification::MatchesGenerator.any_instance.unstub(:attr_to_value)
    end

    test '#enc should not return class parameters when default value should use puppet default' do
      lkey = FactoryBot.create(:puppetclass_lookup_key, :with_override, :with_omit,
        puppetclass: puppetclass)

      enc = HostInfoProviders::PuppetInfo.new(@host).puppetclass_parameters
      assert_nil enc[puppetclass.name][lkey.key]
    end

    test '#enc should not return class parameters when lookup_value should use puppet default' do
      lkey = FactoryBot.create(:puppetclass_lookup_key, :with_override, :with_omit,
        puppetclass: puppetclass, path: "location\ncomment")
      as_admin do
        LookupValue.create! lookup_key_id: lkey.id,
          match: "location=#{taxonomies(:location1)}",
          value: 'test',
          omit: true
      end

      enc = HostInfoProviders::PuppetInfo.new(@host).puppetclass_parameters

      assert_nil enc[puppetclass.name][lkey.key]
    end

    test '#enc should return class parameters when default value and lookup_values should not use puppet default' do
      lkey = FactoryBot.create(:puppetclass_lookup_key, :with_override, omit: false,
                                                                        puppetclass: puppetclass,
                                                                        path: "location\ncomment")
      lvalue = as_admin do
        LookupValue.create! lookup_key_id: lkey.id,
          match: "location=#{taxonomies(:location1)}",
          value: 'test',
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(@host).puppetclass_parameters

      assert_equal lvalue.value, enc[puppetclass.name][lkey.key]
    end

    test '#enc should not return class parameters when merged lookup_values and default are all using puppet default' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       key_type: 'hash', merge_overrides: true,
                                                       default_value: {}, path: "organization\nos\nlocation",
                                                       puppetclass: puppetclass)

      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{taxonomies(:location1)}",
          value: { example: { a: 'test' } },
          omit: true
      end
      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{taxonomies(:organization1)}",
          value: { example: { b: 'test2' } },
          omit: true
      end

      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "os=#{operatingsystems(:redhat)}",
          value: { example: { a: 'test3' } },
          omit: true
      end

      enc = HostInfoProviders::PuppetInfo.new(@host).puppetclass_parameters

      assert_nil enc[puppetclass.name][key.key]
    end

    test '#enc should return correct merged override to host when multiple overrides for inherited hostgroups exist' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       key_type: 'array', merge_overrides: true,
                                                       path: "organization\nhostgroup\nlocation",
                                                       puppetclass: puppetclass_two)

      parent_hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc,
        puppetclasses: [puppetclass_two],
        environment: environment)
      child_hostgroup = FactoryBot.build(:hostgroup, :with_puppet_enc, parent: parent_hostgroup)

      host = FactoryBot.create(:host, :with_puppet_enc, environment: environment, organization: taxonomies(:organization1),
                                                        puppetclasses: [puppetclass], hostgroup: child_hostgroup)

      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "hostgroup=#{parent_hostgroup}",
          value: ['parent'],
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{taxonomies(:organization1)}",
          value: ['org'],
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters

      assert_equal %w[org parent], enc[puppetclass_two.name][key.key]
    end

    test '#enc should return correct merged override to host when multiple overrides for inherited organizations exist' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       key_type: 'array', merge_overrides: true,
                                                       path: "location\norganization\nhostgroup",
                                                       puppetclass: puppetclass_two)

      parent_org = taxonomies(:organization1)
      child_org = taxonomies(:organization2)
      child_org.update(parent: parent_org)

      host = FactoryBot.create(:host, :with_puppet_enc, environment: environment,
                                                        puppetclasses: [puppetclass_two],
                                                        organization: child_org,
                                                        location: taxonomies(:location1))

      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{parent_org}",
          value: ['parent'],
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{taxonomies(:location1)}",
          value: ['loc'],
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters

      assert_equal %w[loc parent], enc[puppetclass_two.name][key.key]
    end

    test '#enc should return correct merged override to host when multiple overrides for inherited locations exist' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       key_type: 'array', merge_overrides: true,
                                                       path: "organization\nhostgroup\nlocation",
                                                       puppetclass: puppetclass_two)

      parent_loc = taxonomies(:location1)
      child_loc = taxonomies(:location2)
      child_loc.update(parent: parent_loc)

      host = FactoryBot.create(:host, :with_puppet_enc, environment: environment,
                                                        puppetclasses: [puppetclass_two],
                                                        organization: taxonomies(:organization1),
                                                        location: child_loc)

      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{parent_loc}",
          value: ['parent'],
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{taxonomies(:organization1)}",
          value: ['org'],
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters

      assert_equal %w[org parent], enc[puppetclass_two.name][key.key]
    end

    test '#enc should return correct merged override to host when multiple overrides for inherited hostgroups exist' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       key_type: 'array', merge_overrides: true,
                                                       path: "organization\nhostgroup\nlocation",
                                                       puppetclass: puppetclass_two)

      parent_hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc,
        puppetclasses: [puppetclass_two],
        environment: environment)
      child_hostgroup = FactoryBot.build(:hostgroup, :with_puppet_enc, parent: parent_hostgroup)

      host = FactoryBot.create(:host, :with_puppet_enc, environment: environment, organization: taxonomies(:organization1),
                                                        puppetclasses: [puppetclass], hostgroup: child_hostgroup)

      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "hostgroup=#{parent_hostgroup}",
          value: ['parent'],
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "hostgroup=#{child_hostgroup}",
          value: ['child'],
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{taxonomies(:organization1)}",
          value: ['org'],
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters

      assert_equal %w[org child parent], enc[puppetclass_two.name][key.key]
    end

    test '#enc should return correct merged override to host when multiple overrides for inherited organizations exist' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       key_type: 'array', merge_overrides: true,
                                                       path: "location\norganization\nhostgroup",
                                                       puppetclass: puppetclass_two)

      parent_org = taxonomies(:organization1)
      child_org = taxonomies(:organization2)
      child_org.update(parent: parent_org)

      host = FactoryBot.create(:host, :with_puppet_enc, environment: environment,
                                                        puppetclasses: [puppetclass_two],
                                                        organization: child_org,
                                                        location: taxonomies(:location1))

      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{parent_org}",
          value: ['parent'],
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{child_org}",
          value: ['child'],
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{taxonomies(:location1)}",
          value: ['loc'],
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters

      assert_equal %w[loc child parent], enc[puppetclass_two.name][key.key]
    end

    test '#enc should return correct merged override to host when multiple overrides for inherited locations exist' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       key_type: 'array', merge_overrides: true,
                                                       path: "organization\nhostgroup\nlocation",
                                                       puppetclass: puppetclass_two)

      parent_loc = taxonomies(:location1)
      child_loc = taxonomies(:location2)
      child_loc.update(parent: parent_loc)

      host = FactoryBot.create(:host, :with_puppet_enc, environment: environment,
                                                        puppetclasses: [puppetclass_two],
                                                        organization: taxonomies(:organization1),
                                                        location: child_loc)

      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{parent_loc}",
          value: ['parent'],
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{child_loc}",
          value: ['child'],
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{taxonomies(:organization1)}",
          value: ['org'],
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters

      assert_equal %w[org child parent], enc[puppetclass_two.name][key.key]
    end

    test '#enc should return correct override to host when multiple overrides for inherited hostgroups exist' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       merge_overrides: false,
                                                       path: "organization\nhostgroup\nlocation",
                                                       puppetclass: puppetclass_two)

      parent_hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc,
        puppetclasses: [puppetclass_two],
        environment: environment)
      child_hostgroup = FactoryBot.build(:hostgroup, :with_puppet_enc, parent: parent_hostgroup)

      host = FactoryBot.create(:host, :with_puppet_enc, environment: environment, organization: taxonomies(:organization1),
                                                        puppetclasses: [puppetclass], hostgroup: child_hostgroup)

      value2 = as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "hostgroup=#{parent_hostgroup}",
          value: 'parent',
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "hostgroup=#{child_hostgroup}",
          value: 'child',
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{taxonomies(:organization1)}",
          value: 'org',
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters

      assert_equal value2.value, enc[puppetclass_two.name][key.key]
    end

    test '#enc should return correct override to host when multiple overrides for inherited organizations exist' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       merge_overrides: false,
                                                       path: "location\norganization\nhostgroup",
                                                       puppetclass: puppetclass_two)

      parent_org = taxonomies(:organization1)
      child_org = taxonomies(:organization2)
      child_org.update(parent: parent_org)

      host = FactoryBot.create(:host, :with_puppet_enc, environment: environment, organization: child_org,
                                                        puppetclasses: [puppetclass_two], location: taxonomies(:location1))

      value2 = as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{parent_org}",
          value: 'parent',
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{child_org}",
          value: 'child',
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{taxonomies(:location1)}",
          value: 'loc',
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters

      assert_equal value2.value, enc[puppetclass_two.name][key.key]
    end

    test '#enc should return correct override to host when multiple overrides for inherited locations exist' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       merge_overrides: false,
                                                       path: "organization\nlocation\nhostgroup",
                                                       puppetclass: puppetclass_two)

      parent_loc = taxonomies(:location1)
      child_loc = taxonomies(:location2)
      child_loc.update(parent: parent_loc)

      host = FactoryBot.create(:host, :with_puppet_enc, environment: environment, organization: taxonomies(:organization1),
                                                        puppetclasses: [puppetclass_two], location: child_loc)

      value2 = as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{parent_loc}",
          value: 'parent',
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{child_loc}",
          value: 'child',
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{taxonomies(:organization1)}",
          value: 'org',
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters

      assert_equal value2.value, enc[puppetclass_two.name][key.key]
    end

    test '#enc should return correct override to host when multiple overrides for inherited hostgroups exist' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       merge_overrides: false,
                                                       path: "organization\nhostgroup\nlocation",
                                                       puppetclass: puppetclass_two)

      parent_hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc,
        puppetclasses: [puppetclass_two],
        environment: environment)
      child_hostgroup = FactoryBot.build(:hostgroup, parent: parent_hostgroup)

      host = FactoryBot.create(:host, :with_puppet_enc, environment: environment, puppetclasses: [puppetclass], hostgroup: child_hostgroup)

      value2 = as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "hostgroup=#{parent_hostgroup}",
          value: 'parent',
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{taxonomies(:location1)}",
          value: 'loc',
          omit: true
        LookupValue.create! lookup_key_id: key.id,
          match: "hostgroup=#{child_hostgroup}",
          value: 'child',
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters

      assert_equal value2.value, enc[puppetclass_two.name][key.key]
    end

    test '#enc should return correct override to host when multiple overrides for inherited organizations exist' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       merge_overrides: false,
                                                       path: "organization\nhostgroup\nlocation",
                                                       puppetclass: puppetclass_two)

      parent_org = taxonomies(:organization1)
      child_org = taxonomies(:organization2)
      child_org.update(parent: parent_org)

      host = FactoryBot.create(:host, :with_puppet_enc, environment: environment,
                                                        puppetclasses: [puppetclass_two],
                                                        organization: child_org,
                                                        location: taxonomies(:location1))

      value2 = as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{parent_org}",
          value: 'parent',
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{taxonomies(:location1)}",
          value: 'loc',
          omit: true
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{child_org}",
          value: 'child',
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters

      assert_equal value2.value, enc[puppetclass_two.name][key.key]
    end

    test '#enc should return correct override to host when multiple overrides for inherited locations exist' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       merge_overrides: false,
                                                       path: "location\norganization\nhostgroup",
                                                       puppetclass: puppetclass_two)

      parent_loc = taxonomies(:location1)
      child_loc = taxonomies(:location2)
      child_loc.update(parent: parent_loc)

      host = FactoryBot.create(:host, :with_puppet_enc, environment: environment,
                                                        puppetclasses: [puppetclass_two],
                                                        organization: taxonomies(:organization1),
                                                        location: child_loc)

      value2 = as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{parent_loc}",
          value: 'parent',
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{taxonomies(:organization1)}",
          value: 'org',
          omit: true
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{child_loc}",
          value: 'child',
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters

      assert_equal value2.value, enc[puppetclass_two.name][key.key]
    end

    test 'enc should return correct values for multi-key matchers' do
      key = FactoryBot.create(:puppetclass_lookup_key,
        default_value: '',
        path: "organization\norganization,location\nlocation",
        puppetclass: puppetclass)

      value2 = as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{taxonomies(:location1)}",
          value: 'test_incorrect',
          omit: false
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{taxonomies(:organization1)},location=#{taxonomies(:location1)}",
          value: 'test_correct',
          omit: false
      end
      enc = HostInfoProviders::PuppetInfo.new(@host).puppetclass_parameters
      key.reload

      assert_equal value2.value, enc[puppetclass.name][key.key]
    end

    test 'enc should return correct values for multi-key matchers with more specific first' do
      key = FactoryBot.create(:puppetclass_lookup_key,
        default_value: '',
        path: "organization,location\norganization",
        puppetclass: puppetclass)

      value = as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{taxonomies(:organization1)},location=#{taxonomies(:location1)}",
          value: 'test_correct',
          omit: false
      end
      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{taxonomies(:organization1)}",
          value: 'test_incorrect',
          omit: false
      end
      enc = HostInfoProviders::PuppetInfo.new(@host).puppetclass_parameters

      assert_equal value.value, enc[puppetclass.name][key.key]
    end

    test 'enc should return correct values for multi-key matchers with hostgroup inheritance' do
      key = FactoryBot.create(:puppetclass_lookup_key, omit: true,
                                                       merge_overrides: false,
                                                       path: "hostgroup,organization\nlocation",
                                                       puppetclass: puppetclass_two)

      parent_hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc,
        puppetclasses: [puppetclass_two],
        environment: environment)
      child_hostgroup = FactoryBot.build(:hostgroup, :with_puppet_enc, parent: parent_hostgroup)

      host = FactoryBot.create(:host, :with_puppet_enc, environment: environment,
                                                        location: taxonomies(:location1), organization: taxonomies(:organization1),
                                                        puppetclasses: [puppetclass], hostgroup: child_hostgroup)

      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "hostgroup=#{parent_hostgroup},organization=#{taxonomies(:organization1)}",
          value: 'parent',
          omit: false
      end
      value2 = as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "hostgroup=#{child_hostgroup},organization=#{taxonomies(:organization1)}",
          value: 'child',
          omit: false
      end

      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{taxonomies(:location1)}",
          value: 'loc',
          omit: false
      end

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters
      key.reload
      assert_equal value2.value, enc[puppetclass_two.name][key.key]
    end

    test 'smart class parameter should accept string with erb for arrays and evaluate it properly' do
      key = FactoryBot.create(:puppetclass_lookup_key,
        key_type: 'array', merge_overrides: false,
        default_value: '<%= [1,2] %>', path: "organization\nos\nlocation",
        puppetclass: puppetclass)
      assert_equal [1, 2], HostInfoProviders::PuppetInfo.new(@host).puppetclass_parameters[puppetclass.name][key.key]

      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{taxonomies(:location1)}",
          value: '<%= [2,3] %>',
          omit: false
      end
      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "organization=#{taxonomies(:organization1)}",
          value: '<%= [3,4] %>',
          omit: false
      end
      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "os=#{operatingsystems(:redhat)}",
          value: '<%= [4,5] %>',
          omit: false
      end

      key.reload

      assert_equal({ key.id => { key.key => { value: '<%= [3,4] %>',
                                              element: 'organization',
                                              element_name: 'Organization 1',
                                              managed: false } } },
        Classification::ValuesHashQuery.values_hash(@host, LookupKey.where(id: [key])).raw)
      assert_equal [3, 4], HostInfoProviders::PuppetInfo.new(@host).puppetclass_parameters[puppetclass.name][key.key]
    end

    test 'enc should return correct values for multi-key matchers' do
      hostgroup = FactoryBot.build(:hostgroup, :with_puppet_enc)

      key = FactoryBot.create(:puppetclass_lookup_key, :with_omit,
        merge_overrides: false,
        path: "hostgroup,organization\nlocation",
        puppetclass: puppetclass_two)

      parent_hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc,
        puppetclasses: [puppetclass_two],
        environment: environment)
      hostgroup.update(parent: parent_hostgroup)

      FactoryBot.build(:lookup_value, lookup_key_id: key.id, match: "hostgroup=#{parent_hostgroup},organization=#{taxonomies(:organization1)}")
      lv = FactoryBot.create(:lookup_value, lookup_key_id: key.id, match: "hostgroup=#{hostgroup},organization=#{taxonomies(:organization1)}")
      FactoryBot.build(:lookup_value, lookup_key_id: key.id, match: "location=#{taxonomies(:location1)}")

      host = FactoryBot.build_stubbed(:host, :with_puppet_enc, hostgroup: hostgroup,
                                                               environment: environment,
                                                               location: taxonomies(:location1),
                                                               organization: taxonomies(:organization1))

      enc = HostInfoProviders::PuppetInfo.new(host).puppetclass_parameters
      key.reload
      assert_equal lv.value, enc[puppetclass_two.name][key.key]
    end

    test 'smart class parameter with erb values is validated after erb is evaluated' do
      key = FactoryBot.create(:puppetclass_lookup_key,
        merge_overrides: false,
        default_value: '<%= "a" %>', path: "organization\nos\nlocation",
        puppetclass: puppetclass,
        validator_type: 'list', validator_rule: 'b')

      assert_raise RuntimeError do
        HostInfoProviders::PuppetInfo.new(@host).puppetclass_parameters[puppetclass.name][key.key]
      end

      key.update(default_value: '<%= "b" %>')
      assert_equal 'b', HostInfoProviders::PuppetInfo.new(@host).puppetclass_parameters[puppetclass.name][key.key]

      as_admin do
        LookupValue.create! lookup_key_id: key.id,
          match: "location=#{taxonomies(:location1)}",
          value: '<%= "c" %>',
          omit: false
      end

      key.reload

      assert_raise RuntimeError do
        HostInfoProviders::PuppetInfo.new(@host).puppetclass_parameters[puppetclass.name][key.key]
      end
    end

    private

    def get_classparam(env, classes)
      host = Host.new
      puppet_mock = mock('HostPuppetFacet')
      puppet_mock.stubs(environment: env, environment_id: env.id)
      host.stubs(:puppet).returns(puppet_mock)
      puppet_mock.expects(:classes).returns(Array.wrap(classes))
      puppet_mock.expects(:puppetclass_ids).returns(Array.wrap(classes).map(&:id))
      HostInfoProviders::PuppetInfo.new(host)
    end
  end
end
