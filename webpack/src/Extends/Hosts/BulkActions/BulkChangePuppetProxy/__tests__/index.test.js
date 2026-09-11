import React from 'react';
import { screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import '@testing-library/jest-dom';

import { openBulkModal } from 'foremanReact/common/BulkModalStateHelper';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';
import { rtlHelpers } from 'foremanReact/common/rtlTestHelpers';
import API from 'foremanReact/redux/API/API';

import BulkChangePuppetProxyScene from '../index';

jest.mock('foremanReact/redux/API', () => ({
  ...jest.requireActual('foremanReact/redux/API'),
}));

jest.mock('foremanReact/redux/API/APISelectors', () =>
  jest.requireActual('foremanReact/redux/API/APISelectors')
);

const { renderWithStoreAndI18n } = rtlHelpers;

const MODAL_ID = 'bulk-change-puppet-proxy';

const fetchBulkParams = jest.fn(() => 'id ^ (1,2)');
const refreshTableData = jest.fn();

const defaultContextValue = {
  selectAllHostsMode: false,
  selectedCount: 2,
  selectedResults: [1, 2],
  fetchBulkParams,
  refreshTableData,
};

const smartProxiesResponse = {
  data: {
    results: [{ id: 1, name: 'proxy1.example.com' }],
  },
};

const renderScene = ({ contextValue = defaultContextValue } = {}) =>
  renderWithStoreAndI18n(
    <ForemanActionsBarContext.Provider value={contextValue}>
      <BulkChangePuppetProxyScene />
    </ForemanActionsBarContext.Provider>
  );

describe('BulkChangePuppetProxyScene', () => {
  beforeEach(() => {
    openBulkModal(MODAL_ID, false);
    API.get.mockImplementation(() => Promise.resolve(smartProxiesResponse));
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('does not show the modal when bulk modal state is closed', () => {
    renderScene();

    expect(
      screen.queryByRole('dialog', { name: 'Change Puppet Proxy' })
    ).not.toBeInTheDocument();
  });

  it('opens the modal with Puppet Proxy content when bulk modal is open', async () => {
    openBulkModal(MODAL_ID, true);
    renderScene();

    expect(
      await screen.findByRole('dialog', { name: 'Change Puppet Proxy' })
    ).toBeInTheDocument();
    expect(
      screen.getByText(/Changing the Puppet proxy will affect/)
    ).toBeInTheDocument();
    expect(screen.getByText('2')).toBeInTheDocument();
    expect(
      await screen.findByText('Select a Puppet Proxy')
    ).toBeInTheDocument();
    expect(screen.queryByText('Select a Puppet CA Proxy')).not.toBeInTheDocument();
    expect(screen.queryByText('Change Puppet CA Proxy')).not.toBeInTheDocument();
    expect(
      await screen.findByRole('button', { name: 'Change Puppet Proxy' })
    ).toBeDisabled();
    expect(screen.getByRole('button', { name: 'Cancel' })).toBeInTheDocument();
  });

  it('shows the all-hosts warning when select all hosts mode is enabled', async () => {
    openBulkModal(MODAL_ID, true);
    renderScene({
      contextValue: { ...defaultContextValue, selectAllHostsMode: true },
    });

    await screen.findByRole('dialog', { name: 'Change Puppet Proxy' });
    expect(screen.getByText('All')).toBeInTheDocument();
  });

  it('closes the modal when Cancel is clicked', async () => {
    openBulkModal(MODAL_ID, true);
    renderScene();

    await screen.findByRole('dialog', { name: 'Change Puppet Proxy' });
    await userEvent.click(screen.getByRole('button', { name: 'Cancel' }));

    await waitFor(() => {
      expect(
        screen.queryByRole('dialog', { name: 'Change Puppet Proxy' })
      ).not.toBeInTheDocument();
    });
  });
});
