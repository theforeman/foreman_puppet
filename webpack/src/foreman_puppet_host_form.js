/* eslint-disable jquery/no-ajax */
/* eslint-disable jquery/no-class */
/* eslint-disable jquery/no-html */
/* eslint-disable jquery/no-data */
/* eslint-disable jquery/no-show */
/* eslint-disable jquery/no-hide */
/* eslint-disable jquery/no-closest */

import $ from 'jquery';

import { translate as __ } from 'foremanReact/common/I18n';
import store from 'foremanReact/redux';
import * as LayoutActions from 'foremanReact/components/Layout/LayoutActions';

export function loadPuppetClassParameters(item) {
  const id = $(item).data('class-id');
  // host_id could be either host.id OR hostgroup.id depending on which form
  const $form = $('form.hostresource-form');
  if ($form.length <= 0) return; // it is not host nor hostgroup form - probably config_group
  const hostId = $form.data('id');
  if ($(`#puppetclass_${id}_params_loading`).length > 0) return; // already loading
  if ($(`[id^="#puppetclass_${id}_params\\["]`).length > 0) return; // already loaded
  const url = $(item).data('url');
  let data = window.serializeForm().replace('method=patch', 'method=post');
  if (url?.match('hostgroups')) {
    data += `&hostgroup_id=${hostId}`;
  } else {
    data += `&host_id=${hostId}`;
  }

  if (!url) return; // no parameters
  const spinner = window.spinner_placeholder(__('Loading parameters...'));
  const placeholder = $(
    `<tr id="puppetclass_${id}_params_loading"><td colspan="5">${spinner}</td></tr>`
  );
  $('#puppet_klasses_parameters_table').append(placeholder);
  $.ajax({
    type: 'post',
    url,
    data,
    success: (result, textstatus, xhr) => {
      const params = $(result);
      placeholder.replaceWith(params);
      params.find('a[rel="popover"]').popover();
      if (params.find('.error').length > 0)
        $('#puppet_enc_tab').addClass('tab-error');
    },
  });
}

export function updatePuppetclasses(element) {
  const hostId = $('form.hostresource-form').data('id');
  const url = $('#puppet_klasses_reload_url').data('url');
  let data = window.serializeForm().replace('method=patch', 'method=post');

  if (element.value === '') return;
  if (url.match('hostgroups')) {
    data += `&hostgroup_id=${hostId}`;
  } else {
    data += `&host_id=${hostId}`;
  }

  store.dispatch(LayoutActions.showLoading());
  window.tfm.tools.showSpinner();
  $.ajax({
    type: 'post',
    url,
    data,
    success: request => {
      $('#puppet_enc_tab').html(request);
      window.tfm.tools.activateTooltips();
      checkForUnavailablePuppetclasses();
    },
    complete: () => {
      store.dispatch(LayoutActions.hideLoading());
      // TODO do only the necessary - we know what we are loading here
      window.reloadOnAjaxComplete(element);
    },
  });
}

export function reloadPuppetclassParams() {
  const hostId = $('form.hostresource-form').data('id');
  const url = $('#puppet_klasses_parameters').data('url');
  if (!url) {
    return;
  }
  let data = window.serializeForm().replace('method=patch', 'method=post');
  if (url.match('hostgroups')) {
    data += `&hostgroup_id=${hostId}`;
  } else {
    data += `&host_id=${hostId}`;
  }
  window.load_with_placeholder('puppet_klasses_parameters_table', url, data);
}

export function checkForUnavailablePuppetclasses() {
  const unavailableClasses = $(
    '#puppet_enc_tab #selected_classes .unavailable'
  );
  const puppetEncTab = $('#puppet_enc_tab');
  const tab = puppetEncTab
    .closest('form')
    .find('.nav-tabs a[href="#puppet_enc_tab"]');
  const warningMessage = __(
    'Some Puppet Classes are unavailable in the selected environment'
  );
  const warning = `<div class="alert alert-warning" id="puppetclasses_unavailable_warning">
      <span class="pficon pficon-warning-triangle-o"></span>
      ${warningMessage}
    </span>`;

  if (unavailableClasses.length > 0) {
    if (puppetEncTab.find('#puppetclasses_unavailable_warning').length <= 0) {
      tab.prepend('<span class="pficon pficon-warning-triangle-o"></span> ');
      puppetEncTab.prepend(warning);
    }
  } else {
    puppetEncTab.find('#puppetclasses_unavailable_warning').remove();
    tab.find('.pficon-warning-triangle-o').remove();
  }
}

export function overridePuppetclassParam(item) {
  const remove = $(item).data('tag') === 'remove';
  const row = $(item)
    .closest('tr')
    .toggleClass('overridden');
  const value = row.find('textarea') || row.find('select');
  row
    .find('[type=checkbox]')
    .prop('checked', false)
    .toggle();
  row.find('input, textarea').prop('disabled', remove);
  row.find('input, select').prop('disabled', remove);
  row.find('.send_to_remove').prop('disabled', false);
  row.find('.destroy').val(remove);
  value.val(value.attr('data-inherited-value'));
  $(item)
    .hide()
    .siblings('.btn-override')
    .show();
}
