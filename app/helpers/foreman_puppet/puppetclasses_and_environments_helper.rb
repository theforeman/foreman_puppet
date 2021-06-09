module ForemanPuppet
  module PuppetclassesAndEnvironmentsHelper
    def class_update_text(pcs, env)
      if pcs.empty?
        _('Empty environment')
      elsif pcs == ['_destroy_']
        _('Deleted environment')
      elsif pcs.delete '_destroy_'
        format(_('Deleted environment %{env} and %{pcs}'), env: env, pcs: pcs.to_sentence)
      elsif pcs == ['_ignored_']
        _('Ignored environment')
      else
        module_puppetclasses(pcs.is_a?(Hash) ? pcs.keys : pcs)
      end
    end

    def import_proxy_select(hash)
      select_action_button(_('Import'), {}, import_proxy_links(hash, true))
    end

    def import_proxy_links(hash, import_env_text = false, classes = nil)
      import_from_text = import_env_text ? _('Import environments from %s') : _('Import classes from %s')
      SmartProxy.with_features('Puppet').map do |proxy|
        display_link_if_authorized(import_from_text % proxy.name, hash.merge(proxy: proxy), { class: classes })
      end.flatten
    end

    private

    def module_puppetclasses(classes)
      mod_classes = {}
      classes.each do |klass|
        if (mod = klass.gsub(/::.*/, ''))
          mod_classes[mod] ||= []
          mod_classes[mod] << klass
        end
      end
      mod_classes.keys.sort.map do |mod_name|
        num = mod_classes[mod_name].size
        num_tag = tag.span(num.to_s, class: 'label label-info')
        tag.a(
          mod_name,
          rel: 'popover',
          data: { content: mod_classes[mod_name].sort.join('<br>').html_safe,
                  'original-title': format(n_('%{name} has %{num_tag} class', '%{name} has %{num_tag} classes', num), name: mod_name, num_tag: num_tag),
                  trigger: 'focus',
                  container: 'body',
                  html: true },
          role: 'button',
          tabindex: '-1'
        )
      end.to_sentence.html_safe
    end
  end
end
