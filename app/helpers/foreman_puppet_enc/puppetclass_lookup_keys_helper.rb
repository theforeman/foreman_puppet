module ForemanPuppetEnc
  module PuppetclassLookupKeysHelper
    def puppetclass_lookup_keys_breadcrumbs
      breadcrumbs(resource_url: api_smart_class_parameters_path,
                  name_field: 'parameter',
                  switcher_item_url: '/puppetclass_lookup_keys/:id-:name/edit')
    end

    # ------ Host(group) Form Helpers -----

    def overridable_puppet_lookup_keys(klass, obj)
      klass.class_params.override.where(environment_classes: { environment_id: obj.environment })
    end

    def hidden_puppet_lookup_value_fields(lookup_key, lookup_value, disabled)
      return unless can_edit_params?
      value_prefix = lookup_value_name_prefix(lookup_key.id)
      hidden_field(value_prefix, :lookup_key_id, value: lookup_key.id,
                                                 disabled: disabled, class: 'send_to_remove') +
        hidden_field(value_prefix, :id, value: lookup_value.id,
                                        disabled: disabled, class: 'send_to_remove') +
        hidden_field(value_prefix, :_destroy, value: false,
                                              disabled: disabled, class: 'send_to_remove destroy')
    end

    def omit_puppet_lookup_check_box(lookup_key, lookup_value, disabled)
      check_box(lookup_value_name_prefix(lookup_key.id), :omit,
        value: lookup_value.id,
        disabled: disabled || !can_edit_params?,
        onchange: "toggleOmitValue(this, 'value')",
        hidden: disabled,
        title: _('Omit from classification output'),
        checked: lookup_value.omit)
    end

    def puppet_override_toggle(overridden)
      return unless can_edit_params?
      link_to_function(icon_text('pencil-square-o', '', kind: 'fa'), 'tfm.puppetEnc.hostForm.overridePuppetclassParam(this)',
        title: _('Override this value'),
        'data-tag': 'override',
        class: "btn btn-default btn-md btn-override #{'hide' if overridden}") +
        link_to_function(icon_text('times', '', kind: 'fa'), 'tfm.puppetEnc.hostForm.overridePuppetclassParam(this)',
          title: _('Remove this override'),
          'data-tag': 'remove',
          class: "btn btn-default btn-md btn-override #{'hide' unless overridden}")
    end

    def puppet_lookup_key_with_diagnostic(obj, lookup_key, lookup_value)
      value, matcher = lookup_value_matcher(obj, lookup_key)
      inherited_value = LookupKey.format_value_before_type_cast(value, lookup_key.key_type)
      effective_value = lookup_value.lookup_key_id.nil? ? inherited_value.to_s : lookup_value.value_before_type_cast.to_s
      warnings = lookup_key_warnings(lookup_key.required, effective_value.present?)
      popover_value = lookup_key.hidden_value? ? lookup_key.hidden_value : inherited_value

      parameter_value_content(
        "#{parameters_receiver}_lookup_values_attributes_#{lookup_key.id}_value",
        effective_value,
        popover: diagnostic_popover(lookup_key, matcher, popover_value, warnings),
        name: "#{lookup_value_name_prefix(lookup_key.id)}[value]",
        disabled: !lookup_key.overridden?(obj) || lookup_value.omit || !can_edit_params?,
        inherited_value: inherited_value,
        lookup_key: lookup_key,
        hidden_value?: lookup_key.hidden_value?,
        lookup_key_type: lookup_key.key_type
      )
    end

    def lookup_value_matcher(obj, lookup_key)
      if parameters_receiver == 'host'
        value = puppet_lookup_value_hash_host_cache(obj)[lookup_key.id]
        value_for_key = value.try(:[], lookup_key.key)
        if value_for_key.present?
          [value_for_key[:value], "#{value_for_key[:element]} (#{value_for_key[:element_name]})"]
        else
          [lookup_key.default_value, _('Default value')]
        end
      else # hostgroup
        obj.inherited_lookup_value(lookup_key)
      end
    end

    # rubocop:disable Rails/HelperInstanceVariable
    def puppet_lookup_value_hash_host_cache(host)
      @puppet_lookup_value_hash_host_cache ||= {}
      @puppet_lookup_value_hash_host_cache[host.id] ||= ForemanPuppetEnc::HostInfoProviders::PuppetInfo.new(host).inherited_puppetclass_parameters
    end
    # rubocop:enable Rails/HelperInstanceVariable

    def diagnostic_popover(lookup_key, matcher, inherited_value, warnings)
      description = lookup_key_description(lookup_key, matcher, inherited_value)
      popover('', description.prepend(warnings[:text]),
        data: { placement: 'top' },
        title: _('Original value info'),
        icon: 'info-circle',
        kind: 'fa')
    end

    def lookup_key_description(lookup_key, matcher, inherited_value)
      format(_("<b>Description:</b> %{desc}<br/>
        <b>Type:</b> %{type}<br/>
        <b>Matcher:</b> %{matcher}<br/>
        <b>Inherited value:</b> %{inherited_value}"),
        desc: html_escape(lookup_key.description),
        type: lookup_key.key_type,
        matcher: html_escape(matcher),
        inherited_value: html_escape(inherited_value))
    end

    def lookup_key_warnings(required, has_value)
      return { text: '', icon: 'info' } if has_value

      if required
        { text: _('Required parameter without value.<br/><b>Please override!</b><br/>'),
          icon: 'error-circle-o' }
      else
        { text: _('Optional parameter without value.<br/><i>Still managed by Foreman, the value will be empty.</i><br/>'),
          icon: 'warning-triangle-o' }
      end
    end

    # Input tags used to override lookup keys need a 'name' HTML attribute to
    # tell Rails which lookup_value they belong to.
    # This method returns the name attribute for any combination of lookup_key
    # and host/hostgroup. Other objects that may receive parameters too will need
    # to override this method in their respective helpers.
    def lookup_value_name_prefix(lookup_key_id)
      "#{parameters_receiver}[lookup_values_attributes][#{lookup_key_id}]"
    end

    def parameters_receiver
      return 'host' if params.key?(:host) || params[:controller] == 'hosts'
      'hostgroup'
    end
  end
end
