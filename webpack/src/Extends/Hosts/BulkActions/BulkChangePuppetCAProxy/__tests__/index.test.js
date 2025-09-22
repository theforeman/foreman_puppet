import React from 'react';
import { mount } from '@theforeman/test';

import { openBulkModal } from 'foremanReact/common/BulkModalStateHelper';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';

import BulkChangePuppetCAProxyScene from '../index';
import BulkChangeProxyCommon from '../../BulkChangeProxyCommon';

jest.mock('foremanReact/components/HostDetails/ActionsBar', () => ({
  ForemanActionsBarContext: jest.requireActual('react').createContext(),
}));

jest.mock('../../BulkChangeProxyCommon', () => ({
  __esModule: true,
  default: jest.fn(() => null),
}));

describe('BulkChangePuppetCAProxyScene', () => {
  const fetchBulkParams = jest.fn();
  const contextValue = {
    selectAllHostsMode: false,
    selectedCount: 2,
    selectedResults: [1, 2],
    fetchBulkParams,
  };

  beforeEach(() => {
    jest.clearAllMocks();
    openBulkModal('bulk-change-puppet-ca-proxy', false);
  });

  it('opens with bulk modal state and passes expected CA proxy props', () => {
    openBulkModal('bulk-change-puppet-ca-proxy', true);
    const wrapper = mount(
      <ForemanActionsBarContext.Provider value={contextValue}>
        <BulkChangePuppetCAProxyScene />
      </ForemanActionsBarContext.Provider>
    );

    const componentType =
      BulkChangeProxyCommon.default || BulkChangeProxyCommon;
    const props = wrapper.find(componentType).props();

    expect(props).toEqual(
      expect.objectContaining({
        isCAProxy: true,
        fetchBulkParams,
        selectedCount: 2,
        selectedResults: [1, 2],
        selectAllHostsMode: false,
        isOpen: true,
        closeModal: expect.any(Function),
        selectMessage: 'Select a Puppet CA Proxy',
        handleErrorMessage: 'Failed to change Puppet CA Proxy',
        changeMessage: 'Change Puppet CA Proxy',
        allHostsMessage:
          'Changing the Puppet CA proxy will affect {boldCount} selected hosts. Some hosts may already have been associated with the selected Puppet CA proxy.',
        someHostsMessage:
          'Changing the Puppet CA proxy will affect {boldCount} selected {count, plural, one {host} other {hosts}}. Some hosts may already have been associated with the selected Puppet CA proxy.',
      })
    );

    wrapper.unmount();
  });
});
