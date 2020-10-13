module ForemanPuppetEnc
  module PuppetclassLookupKeysHelper
    def puppetclass_lookup_keys_breadcrumbs
      breadcrumbs(resource_url: api_smart_class_parameters_path,
                  name_field: 'parameter',
                  switcher_item_url: '/puppetclass_lookup_keys/:id-:name/edit')
    end
  end
end
