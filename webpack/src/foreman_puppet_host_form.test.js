/* eslint-disable jquery/no-size */

import $ from 'jquery';

import { checkForUnavailablePuppetclasses } from './foreman_puppet_host_form';

jest.unmock('jquery');
jest.unmock('./foreman_puppet_host_form');

describe('checkForUnavailablePuppetclasses', () => {
  beforeEach(() => {
    document.body.innerHTML = `<div>
        <ul class="nav-tabs">
          <li><a href="#puppet_enc_tab" data-toggle="tab">Puppet Classes</a></li>
        </ul>
        <div class="tab-content">
          <form>
            <div class="tab-pane active" id="hostgroup">
                <div class="form-group">
                  <div>
                    <input id="hostgroup_environment_id"/>
                  </div>
                  <span class="help-block"></span>
                </div>
            </div>
            <div class="tab-pane" id="puppet_enc_tab">
              <div id="selected_classes"></div>
            </div>
          </form>
        </div>
      </div>`;
  });

  it('adds a warning if an unavailable class is found', () => {
    $('#selected_classes').append(
      '<li class="unavailable">Unavailable Class</li>'
    );

    checkForUnavailablePuppetclasses();
    expect($('#puppetclasses_unavailable_warning').length).toBe(1);
  });

  it('does not add a warning if no unavailable classes are found', () => {
    $('#hostgroup .help-block').empty();
    $('#selected_classes').empty();

    checkForUnavailablePuppetclasses();
    expect(
      $('#hostgroup .help-block')
        .first()
        .children().length
    ).toBe(0);
  });

  it('adds a warning sign to the tab if unavailable classes are found', () => {
    $('#selected_classes').append(
      '<li class="unavailable">Unavailable Class</li>'
    );
    checkForUnavailablePuppetclasses();
    setTimeout(() => {
      expect($('a .pficon').length).toBe(1);
    }, 100);
  });
});
