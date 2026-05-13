import React from 'react';
import { mount } from '@theforeman/test';

import { openBulkModal } from 'foremanReact/common/BulkModalStateHelper';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';

import BulkRemovePuppetProxyScene from '../index';
import BulkRemoveProxyCommon from '../../BulkRemoveProxyCommon';

jest.mock('foremanReact/components/HostDetails/ActionsBar', () => ({
  ForemanActionsBarContext: jest.requireActual('react').createContext(),
}));

jest.mock('../../BulkRemoveProxyCommon', () => ({
  __esModule: true,
  default: jest.fn(() => null),
}));

describe('BulkRemovePuppetProxyScene', () => {
  const fetchBulkParams = jest.fn();
  const contextValue = {
    selectAllHostsMode: false,
    selectedCount: 2,
    selectedResults: [1, 2],
    fetchBulkParams,
  };

  beforeEach(() => {
    jest.clearAllMocks();
    openBulkModal('bulk-remove-puppet-proxy', false);
  });

  it('opens with bulk modal state and passes expected props', () => {
    openBulkModal('bulk-remove-puppet-proxy', true);
    const wrapper = mount(
      <ForemanActionsBarContext.Provider value={contextValue}>
        <BulkRemovePuppetProxyScene />
      </ForemanActionsBarContext.Provider>
    );

    const componentType =
      BulkRemoveProxyCommon.default || BulkRemoveProxyCommon;
    const props = wrapper.find(componentType).props();

    expect(props).toEqual(
      expect.objectContaining({
        isCAProxy: false,
        selectAllHostsMode: false,
        selectedCount: 2,
        selectedResults: [1, 2],
        fetchBulkParams,
        isOpen: true,
        closeModal: expect.any(Function),
        handleErrorMessage: 'Failed to remove Puppet Proxy',
        removeMessage: 'Remove Puppet Proxy',
      })
    );

    wrapper.unmount();
  });
});
