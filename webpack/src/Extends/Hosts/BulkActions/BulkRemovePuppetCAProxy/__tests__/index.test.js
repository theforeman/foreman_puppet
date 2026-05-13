import React from 'react';
import { mount } from '@theforeman/test';

import { openBulkModal } from 'foremanReact/common/BulkModalStateHelper';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';

import BulkRemovePuppetCAProxyScene from '../index';
import BulkRemoveProxyCommon from '../../BulkRemoveProxyCommon';

jest.mock('foremanReact/components/HostDetails/ActionsBar', () => ({
  ForemanActionsBarContext: jest.requireActual('react').createContext(),
}));

jest.mock('../../BulkRemoveProxyCommon', () => ({
  __esModule: true,
  default: jest.fn(() => null),
}));

describe('BulkRemovePuppetCAProxyScene', () => {
  const fetchBulkParams = jest.fn();
  const contextValue = {
    selectAllHostsMode: false,
    selectedCount: 2,
    selectedResults: [1, 2],
    fetchBulkParams,
  };

  beforeEach(() => {
    jest.clearAllMocks();
    openBulkModal('bulk-remove-puppet-ca-proxy', false);
  });

  it('opens with bulk modal state and passes expected CA proxy props', () => {
    openBulkModal('bulk-remove-puppet-ca-proxy', true);
    const wrapper = mount(
      <ForemanActionsBarContext.Provider value={contextValue}>
        <BulkRemovePuppetCAProxyScene />
      </ForemanActionsBarContext.Provider>
    );

    const componentType =
      BulkRemoveProxyCommon.default || BulkRemoveProxyCommon;
    const props = wrapper.find(componentType).props();

    expect(props).toEqual(
      expect.objectContaining({
        isCAProxy: true,
        selectAllHostsMode: false,
        selectedCount: 2,
        selectedResults: [1, 2],
        fetchBulkParams,
        isOpen: true,
        closeModal: expect.any(Function),
        handleErrorMessage: 'Failed to remove Puppet CA Proxy',
        allHostsMessage:
          'Removing the Puppet CA proxy will affect {boldCount} selected hosts. Warning: If a Puppet Proxy is still set, the Puppet CA Proxy will fall back to that value after removal!',
        someHostsMessage:
          'Removing the Puppet CA proxy will affect {boldCount} selected {count, plural, one {host} other {hosts}}. Warning: If a Puppet Proxy is still set, the Puppet CA Proxy will fall back to that value after removal!',
        removeMessage: 'Remove Puppet CA Proxy',
      })
    );

    wrapper.unmount();
  });
});
