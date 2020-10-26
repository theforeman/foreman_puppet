import $ from 'jquery';

import * as classEditor from './src/foreman_class_edit';
import * as hostForm from './src/foreman_puppet_host_form';

window.tfm = Object.assign(window.tfm || {}, {
  classEditor,
  puppetEnc: {
    hostForm,
  },
});

// TODO: the checkForUnavailablePuppetclasses is very nasty
$(document)
  .on('change', '.hostgroup-select', evt => {
    const form = $('form.host-form')[0];
    if (form && form.dataset.id) hostForm.updatePuppetclasses(evt.target);
  })
  .on('change', '.interface_domain', evt => {
    hostForm.reloadPuppetclassParams();
  })
  .on('change', '.host-architecture-os-select', evt => {
    hostForm.reloadPuppetclassParams();
  })
  .on('ContentLoad', evt => {
    hostForm.checkForUnavailablePuppetclasses();
  });
$(window).on('load', evt => {
  hostForm.checkForUnavailablePuppetclasses();
});
