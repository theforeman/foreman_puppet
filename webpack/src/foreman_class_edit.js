/* eslint-disable jquery/no-val */
/* eslint-disable jquery/no-fade */
/* eslint-disable jquery/no-sizzle */
/* eslint-disable jquery/no-attr */
/* eslint-disable jquery/no-trigger */
/* eslint-disable jquery/no-show */
/* eslint-disable jquery/no-class */
/* eslint-disable jquery/no-find */ /**/
/* eslint-disable jquery/no-parent */
/* eslint-disable jquery/no-clone */
/* eslint-disable jquery/no-hide */
/* eslint-disable jquery/no-each */
/* eslint-disable jquery/no-in-array */
/* eslint-disable jquery/no-closest */
/* eslint-disable jquery/no-data */

import $ from 'jquery';
import { sprintf, translate as __ } from 'foremanReact/common/I18n';

export function filterPuppetClasses(item) {
  const term = $(item)
    .val()
    .trim();
  const classElems = $('.available_classes').find(
    '.puppetclass_group, .puppetclass'
  );
  if (term.length > 0) {
    classElems
      .hide()
      .has(`[data-class-name*="${term}"]`)
      .show()
      .filter('div')
      .find('a.collapsed')
      .attr('aria-expanded','true')
      .click();
  } else {
    classElems
      .show()
      .has('.collapse')
      .find('a[aria-expanded]')
      .attr('aria-expanded','false')
      .click();
  }
}

export function addPuppetClass(item) {
  const id = $(item).attr('data-class-id');
  const type = $(item).attr('data-type');
  $(item).tooltip('hide');
  const content = $(item)
    .closest('li')
    .clone();
  content.attr('id', `selected_puppetclass_${id}`);
  content.append(
    `<input id='${type}_puppetclass_ids_' name='${type}[puppetclass_ids][]' type='hidden' value=${id}>`
  );

  const linkIcon = content.children('a.glyphicon');
  const links = content.find('a');

  links.attr('onclick', 'tfm.classEditor.removePuppetClass(this)');
  links.attr(
    'data-original-title',
    sprintf(__('Click to remove %s'), linkIcon.data('class-name'))
  );
  links.tooltip();
  linkIcon.removeClass('glyphicon-plus-sign').addClass('glyphicon-minus-sign');

  $('#selected_classes').append(content);

  $(`#selected_puppetclass_${id}`).show('highlight', 5000);
  $(`#puppetclass_${id}`)
    .addClass('selected-marker')
    .hide();
  findElementsForRemoveIcon($(`#puppetclass_${id}`));

  window.tfm.puppetEnc.hostForm.loadPuppetClassParameters(linkIcon);
}

function addGroupPuppetClass(item) {
  const id = $(item).attr('data-class-id');
  $(item).tooltip('hide');
  const content = $(item)
    .closest('li')
    .clone();
  content.attr('id', `selected_puppetclass_${id}`);
  content.children('span').tooltip();
  content.val('');

  const linkIcon = content.children('a.glyphicon');
  const links = content.find('a');
  links.attr('onclick', '');
  links.attr('data-original-title', __('belongs to config group'));
  links.tooltip();
  linkIcon.removeClass('glyphicon-plus-sign');

  $('#selected_classes').append(content);

  $(`#selected_puppetclass_${id}`).show('highlight', 5000);
  $(`#puppetclass_${id}`)
    .addClass('selected-marker')
    .hide();
  findElementsForRemoveIcon($(`#puppetclass_${id}`));

  window.tfm.puppetEnc.hostForm.loadPuppetClassParameters(linkIcon);
}

export function removePuppetClass(item) {
  const id = $(item).attr('data-class-id');
  $(`#puppetclass_${id}`)
    .removeClass('selected-marker')
    .show();
  $(`#puppetclass_${id}`)
    .parent()
    .prev()
    .find('i')
    .show();
  $(`#puppetclass_${id}`)
    .closest('.puppetclass_group')
    .show();
  $(`#selected_puppetclass_${id}`)
    .children('a')
    .tooltip('hide');
  $(`#selected_puppetclass_${id}`).remove();
  $(`#puppetclass_${id}_params_loading`).remove();
  $(`[id^="puppetclass_${id}_params\\["]`).remove();
  $('a[href="#puppet_enc_tab"]').removeClass('tab-error');
  if ($('#puppet_enc_tab').find('.form-group.error').length > 0)
    $('a[href="#puppet_enc_tab"]').addClass('tab-error');

  return false;
}

function _getInheritedIds() {
  return $('#inherited_ids').data('inherited-puppetclass-ids') || [];
}

export function addConfigGroup(item) {
  const id = $(item).attr('data-group-id');
  const type = $(item).attr('data-type');
  const content = $(item)
    .closest('li')
    .clone();
  content.attr('id', `selected_config_group_${id}`);
  content.append(
    `<input id='config_group_ids' name=${type}[config_group_ids][] type='hidden' value=${id}>`
  );
  $(`#selected_config_group_${id}`).show('highlight', 5000);
  $(`#config_group_${id}`)
    .addClass('selected-marker')
    .hide();
  const link = content.children('a.glyphicon');
  const links = content.find('a');
  link.attr('onclick', 'tfm.classEditor.removeConfigGroup(this)');
  link.attr('data-original-title', __('Click to remove config group'));
  links.tooltip();
  link.removeClass('glyphicon-plus-sign').addClass('glyphicon-minus-sign');
  link.text(__(' Remove'));

  $('#selected_config_groups').append(content);
  $(`#selected_config_group_${id}`).show('highlight', 5000);
  $(`#config_group_${id}`)
    .addClass('selected-marker')
    .hide();

  const puppetclassIds = JSON.parse($(item).attr('data-puppetclass-ids'));
  const inheritedIds = _getInheritedIds();

  $.each(puppetclassIds, (index, puppetclassId) => {
    const pc = $(`li#puppetclass_${puppetclassId}`);
    const pcLink = $(`#puppetclass_${puppetclassId} > a.glyphicon`);
    if (
      pcLink.length > 0 &&
      pc.length > 0 &&
      $.inArray(puppetclassId, inheritedIds) === -1
    ) {
      if ($(`#selected_puppetclass_${puppetclassId}`).length <= 0) {
        addGroupPuppetClass(pcLink);
      }
    }
  });
}

export function removeConfigGroup(item) {
  const id = $(item).attr('data-group-id');
  $(`#config_group_${id}`)
    .removeClass('selected-marker')
    .show();
  $(`#selected_config_group_${id}`)
    .children('a')
    .tooltip('hide');
  $(`#selected_config_group_${id}`).remove();

  const puppetclassIds = JSON.parse($(item).attr('data-puppetclass-ids'));
  const inheritedIds = _getInheritedIds();

  $.each(puppetclassIds, (index, puppetclassId) => {
    const pc = $(`#selected_puppetclass_${puppetclassId}`);
    const pcLink = $(`#puppetclass_${puppetclassId} > a.glyphicon`);
    // do not remove if manually added - having minus icon
    if (
      pcLink.length > 0 &&
      !pcLink.hasClass('glyphicon-minus-sign') &&
      pc.length > 0 &&
      $.inArray(puppetclassId, inheritedIds) === -1
    ) {
      removePuppetClass(pcLink);
    }
  });
  return false;
}

function findElementsForRemoveIcon(element) {
  const clickedElement = element.parent().prev();
  const ulId = `#${element.parent().attr('id')}`;
  removeIconIfEmpty(clickedElement, ulId);
}

export function expandClassList(clickedElement, toggleSelector) {
  $(toggleSelector).fadeToggle();
  $(clickedElement)
    .find('.glyphicon')
    .toggleClass('glyphicon-plus glyphicon-minus');
  removeIconIfEmpty($(clickedElement), toggleSelector);
}

function removeIconIfEmpty(element, ulId) {
  if ($(ulId).children(':visible').length === 0) {
    element.find('.glyphicon').hide();
  } else {
    element.find('.glyphicon').show();
  }
}
