module ForemanPuppet
  module TemplateCombinationsHelper
    def combination(template)
      template.template_combinations.map do |comb|
        str = []
        str << (comb.hostgroup_id.nil? ? _('None') : comb.hostgroup.to_s)
        str << (comb.environment_id.nil? ? _('None') : comb.environment.to_s)
        str.join(' / ')
      end.to_sentence
    end

    def how_templates_are_determined
      text = ['<p>']
      text << _("When editing a template, you must assign a list \
  of operating systems which this template can be used with. Optionally, you can \
  restrict a template to a list of host groups and/or environments.")
      text << '</p><p>'
      text << _("When a Host requests a template (e.g. during provisioning), Foreman \
  will select the best match from the available templates of that type, in the \
  following order:")
      text << '</p><ul>'
      text << "<li>#{_('Host group and Environment')}</li>"
      text << "<li>#{_('Host group only')}</li>"
      text << "<li>#{_('Environment only')}</li>"
      text << "<li>#{_('Operating system default')}</li>"
      text << '</ul>'
      text << tag.p(_('The final entry, Operating System default, can be set by editing the %s page.') %
                (link_to _('Operating System'), main_app.operatingsystems_path))

      alert(class: 'alert-info', header: 'How templates are determined', text: safe_join(text))
    end
  end
end
