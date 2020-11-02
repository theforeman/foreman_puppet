module ForemanPuppetEnc
  module HostsAndHostgroupsHelper
    # TODO: remove me - prevents the puppetclass tab duplication
    # unless ForemanPuppetEnc.extracted_from_core?
    def puppetclasses_tab(puppetclasses_receiver)
    end

    def host_puppet_environment_field(form, select_options = {}, html_options = {})
      select_options = {
        include_blank: true,
        disable_button: _(::HostsAndHostgroupsHelper::INHERIT_TEXT),
        disable_button_enabled: inherited_by_default?(:environment_id, form.object),
        user_set: user_set?(:environment_id),
      }.deep_merge(select_options)

      html_options = {
        data: {
          host: {
            id: form.object.id,
          },
        },
      }.deep_merge(html_options)

      puppet_environment_field(
        form,
        accessible_resource(form.object, :environment),
        select_options,
        html_options
      )
    end

    def hostgroup_puppet_environment_field(form, select_options = {}, html_options = {})
      select_options = {
        include_blank: blank_or_inherit_f(form, :environment),
      }.deep_merge(select_options)

      puppet_environment_field(
        form,
        accessible_resource(form.object, :environment),
        select_options,
        html_options
      )
    end

    def puppet_environment_field(form, environments_choice, select_options = {}, html_options = {})
      html_options = {
        onchange: 'tfm.puppetEnc.hostForm.updatePuppetclasses(this)',
        help_inline: :indicator,
      }.deep_merge(html_options)

      select_f(
        form,
        :environment_id,
        environments_choice,
        :id,
        :to_label,
        select_options,
        html_options
      )
    end

    def puppetclasses_with_parameters_for(obj)
      classes = obj.all_puppetclasses
      ids = classes.reorder(nil).pluck(:id)
      class_vars = ForemanPuppetEnc::PuppetclassLookupKey.reorder(nil)
                                                         .joins(:environment_classes)
                                                         .where(EnvironmentClass.arel_table[:puppetclass_id].in(ids))
                                                         .distinct
                                                         .pluck('environment_classes.puppetclass_id')
      classes.where(id: class_vars)
    end
  end
end
