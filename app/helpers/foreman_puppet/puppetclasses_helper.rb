module ForemanPuppet
  module PuppetclassesHelper
    include PuppetclassesAndEnvironmentsHelper
    include LookupKeysHelper

    def overridden?(puppetclass)
      puppetclass.class_params.present? && puppetclass.class_params.map(&:override).all?
    end

    def puppetclass_in_environment?(environment, puppetclass)
      return false unless environment
      environment.puppetclasses.map(&:id).include?(puppetclass.id)
    end

    def puppetclass_group_with_icon(list, selected)
      css_options = if (list.last - selected).empty?
                      { class: 'hide' }
                    else
                      {}
                    end
      link_to_function(icon_text('plus', list.first, css_options),
        "tfm.classEditor.expandClassList(this, '#pc_#{list.first}')")
    end

    def link_to_remove_puppetclass(klass, type)
      options = options_for_puppetclass_selection(klass, type)
      text = link_to_remove_function(truncate(klass.name, length: 28), options)
      tag.span(text) + link_to_remove_function('', options.merge(class: 'glyphicon glyphicon-minus-sign'))
    end

    def link_to_remove_function(text, options)
      options.delete_if { |key, _value| !options[key].to_s } # otherwise error during template render
      title = (_('Click to remove %s') % options[:"data-class-name"])
      link_to_function(text, 'tfm.classEditor.removePuppetClass(this)', options.merge!('data-original-title': title))
    end

    def link_to_add_puppetclass(klass, type)
      options = options_for_puppetclass_selection(klass, type)
      text = link_to_add_function(truncate(klass.name, length: 28), options)
      tag.span(text) +
        link_to_add_function('', options.merge(class: 'glyphicon glyphicon-plus-sign'))
    end

    def link_to_add_function(text, options)
      link_to_function(text, 'tfm.classEditor.addPuppetClass(this)',
        options.merge('data-original-title': _('Click to add %s') % options[:"data-class-name"]))
    end

    def options_for_puppetclass_selection(klass, type)
      {
        'data-class-id': klass.id,
        'data-class-name': klass.name,
        'data-type': type,
        'data-url': foreman_puppet.parameters_puppetclass_path(id: klass.id),
        rel: 'twipsy',
      }
    end
  end
end
