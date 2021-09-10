module ForemanPuppet
  module HostsAndHostgroupsHelper
    def environment_inherited_by_default?(host)
      return false unless host.hostgroup && host.hostgroup_id_was.nil?
      return false if params[:action] == 'clone'
      return true unless params[:host]
      !params[:host].dig(:puppet_attributes, :environment_id)
    end

    # rubocop:disable Rails/HelperInstanceVariable
    def user_set_environment?
      # if the host has no hostgroup
      return true unless @host&.hostgroup
      # when editing a host, the values are specified explicitly
      return true if params[:action] == 'edit'
      return true if params[:action] == 'clone'
      # check if the user set the field explicitly despite setting a hostgroup.
      params[:host] && params[:host][:hostgroup_id] && params[:host].dig(:puppet_attributes, :environment_id)
    end
    # rubocop:enable Rails/HelperInstanceVariable

    def host_puppet_environment_field(form, select_options = {}, html_options = {})
      form.fields_for(:puppet, form.object.puppet || form.object.build_puppet, include_id: false) do |fields|
        select_options = {
          include_blank: true,
          disable_button: _(::HostsAndHostgroupsHelper::INHERIT_TEXT),
          disable_button_enabled: environment_inherited_by_default?(form.object),
          user_set: user_set_environment?,
        }.deep_merge(select_options)

        html_options = {
          data: {
            host: {
              id: form.object.id,
            },
          },
        }.deep_merge(html_options)

        puppet_environment_field(
          fields,
          accessible_resource(fields.object, 'ForemanPuppet::Environment', association: :environment),
          select_options,
          html_options
        )
      end
    end

    def hostgroup_puppet_environment_field(form, select_options = {}, html_options = {})
      form.fields_for(:puppet, form.object.puppet || form.object.build_puppet, include_id: false) do |fields|
        select_options = {
          include_blank: blank_or_inherit_f(fields, :environment),
        }.deep_merge(select_options)

        puppet_environment_field(
          fields,
          accessible_resource(fields.object, 'ForemanPuppet::Environment', association: :environment),
          select_options,
          html_options
        )
      end
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
      class_vars = ForemanPuppet::PuppetclassLookupKey.reorder(nil)
                                                      .joins(:environment_classes)
                                                      .where(EnvironmentClass.arel_table[:puppetclass_id].in(ids))
                                                      .distinct
                                                      .pluck('environment_classes.puppetclass_id')
      classes.where(id: class_vars)
    end
  end
end
