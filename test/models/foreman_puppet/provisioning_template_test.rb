require 'test_puppet_helper'

module ForemanPuppet
  class ProvisioningTemplateTest < ActiveSupport::TestCase
    let(:environment) { FactoryBot.create(:environment) }

    test 'should save assoications if not snippet' do
      tmplt = ProvisioningTemplate.new
      tmplt.name = 'Some finish script'
      tmplt.template = 'echo $HOME'
      tmplt.template_kind = template_kinds(:finish)
      tmplt.snippet = false # this is the default, but it helps show the case
      tmplt.hostgroups << hostgroups(:common)
      tmplt.environments << environment
      as_admin do
        assert tmplt.save
      end
      assert_equal template_kinds(:finish), tmplt.template_kind
      assert_equal [hostgroups(:common)], tmplt.hostgroups
      assert_equal [environment], tmplt.environments
    end

    test 'should not save assoications if snippet' do
      tmplt          = ProvisioningTemplate.new
      tmplt.name     = 'Default Kickstart'
      tmplt.template = 'Some kickstart goes here'
      tmplt.snippet  = true
      tmplt.template_kind = template_kinds(:ipxe)
      tmplt.hostgroups << hostgroups(:common)
      tmplt.environments << environment
      as_admin do
        assert tmplt.save
      end
      assert_nil tmplt.template_kind
      assert_equal [], tmplt.hostgroups
      assert_equal [], tmplt.environments
      assert_equal [], tmplt.template_combinations
    end

    describe '#find_template by template_combinations' do
      setup do
        @arch = FactoryBot.create(:architecture)
        medium = FactoryBot.create(:medium, name: 'combo_medium', path: 'http://www.example.com/m')
        @os1 = FactoryBot.create(:rhel7_5, media: [medium], architectures: [@arch])
        @hg1 = FactoryBot.create(:hostgroup, name: 'hg1', operatingsystem: @os1, architecture: @arch, medium: @os1.media.first)
        @hg2 = FactoryBot.create(:hostgroup, name: 'hg2', operatingsystem: @os1, architecture: @arch)
        @hg3 = FactoryBot.create(:hostgroup, name: 'hg3', operatingsystem: @os1, architecture: @arch)
        @ev1 = FactoryBot.create(:environment, name: 'env1')
        @ev2 = FactoryBot.create(:environment, name: 'env2')
        @ev3 = FactoryBot.create(:environment, name: 'env3')

        @tk = TemplateKind.find_by(name: 'provision')

        # Most specific template association
        @ct1 = FactoryBot.create(:provisioning_template, name: 'ct1', template_kind: @tk, operatingsystems: [@os1])
        @ct1.template_combinations.create(hostgroup: @hg1, environment: @ev1)

        # HG only
        # We add an association on HG2/EV2 to ensure that we're not just blindly
        # selecting all template_combinations where environment_id => nil
        @ct2 = FactoryBot.create(:provisioning_template, name: 'ct2', template_kind: @tk, operatingsystems: [@os1])
        @ct2.template_combinations.create(hostgroup: @hg1, environment: nil)
        @ct2.template_combinations.create(hostgroup: @hg2, environment: @ev2)

        # Env only
        # We add an association on HG2/EV2 to ensure that we're not just blindly
        # selecting all template_combinations where hostgroup_id => nil
        @ct3 = FactoryBot.create(:provisioning_template, name: 'ct3', template_kind: @tk, operatingsystems: [@os1])
        @ct3.template_combinations.create(hostgroup: nil, environment: @ev1)
        @ct3.template_combinations.create(hostgroup: @hg2, environment: @ev2)

        # Default template for the OS
        @ctd = FactoryBot.create(:provisioning_template, name: 'ctd', template_kind: @tk, operatingsystems: [@os1])
        @ctd.os_default_templates.create(operatingsystem: @os1, template_kind_id: @ctd.template_kind_id)
      end

      test 'finds a matching template with hg and env' do
        assert_equal @ct1.name,
          ProvisioningTemplate.find_template({ kind: @tk.name,
                                               operatingsystem_id: @os1.id,
                                               hostgroup_id: @hg1.id,
                                               environment_id: @ev1.id }).name
      end

      test 'finds a matching template with hg only' do
        assert_equal @ct2.name,
          ProvisioningTemplate.find_template({ kind: @tk.name,
                                               operatingsystem_id: @os1.id,
                                               hostgroup_id: @hg1.id }).name
      end

      test 'finds a matching template with hg and mismatched env' do
        assert_equal @ct2.name,
          ProvisioningTemplate.find_template({ kind: @tk.name,
                                               operatingsystem_id: @os1.id,
                                               hostgroup_id: @hg1.id,
                                               environment_id: @ev3.id }).name
      end

      test 'finds a matching template with env only' do
        assert_equal @ct3.name,
          ProvisioningTemplate.find_template({ kind: @tk.name,
                                               operatingsystem_id: @os1.id,
                                               environment_id: @ev1.id }).name
      end

      test 'finds a matching template with env and mismatched hg' do
        assert_equal @ct3.name,
          ProvisioningTemplate.find_template({ kind: @tk.name,
                                               operatingsystem_id: @os1.id,
                                               hostgroup_id: @hg3.id,
                                               environment_id: @ev1.id }).name
      end

      test 'finds the default template when hg and env do not match' do
        assert_equal @ctd.name,
          ProvisioningTemplate.find_template({ kind: @tk.name,
                                               operatingsystem_id: @os1.id,
                                               hostgroup_id: @hg3.id,
                                               environment_id: @ev3.id }).name
      end
    end
  end
end
