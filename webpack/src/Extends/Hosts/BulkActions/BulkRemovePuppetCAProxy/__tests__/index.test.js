import React from 'react';
import { act, screen, within, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import '@testing-library/jest-dom';

import { rtlHelpers } from 'foremanReact/common/rtlTestHelpers';
import { openBulkModal } from 'foremanReact/common/BulkModalStateHelper';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';
import { APIActions } from 'foremanReact/redux/API';
import API from 'foremanReact/redux/API/API';

import BulkRemovePuppetCAProxyScene from '../index';
import { BULK_REMOVE_PUPPET_CA_PROXY_KEY } from '../../BulkRemoveProxyCommon/actions';

const { renderWithStoreAndI18n } = rtlHelpers;

describe('BulkRemovePuppetCAProxyScene', () => {
  const fetchBulkParams = jest.fn(() => 'id ^ (1,2)');
  const refreshTableData = jest.fn();
  const defaultContextValue = {
    selectAllHostsMode: false,
    selectedCount: 2,
    selectedResults: [1, 2],
    fetchBulkParams,
    refreshTableData,
  };
  let renderResult;

  const renderScene = (contextOverrides = {}, isOpen = true) => {
    openBulkModal('bulk-remove-puppet-ca-proxy', isOpen);

    renderResult = renderWithStoreAndI18n(
      <ForemanActionsBarContext.Provider
        value={{ ...defaultContextValue, ...contextOverrides }}
      >
        <BulkRemovePuppetCAProxyScene />
      </ForemanActionsBarContext.Provider>
    );

    return renderResult;
  };

  beforeEach(() => {
    openBulkModal('bulk-remove-puppet-ca-proxy', false);
    APIActions.put.mockImplementation(params => ({
      type: 'API_PUT',
      payload: params,
    }));
  });

  afterEach(() => {
    renderResult?.unmount();
    jest.clearAllMocks();
  });

  it('does not show the remove modal when bulk modal is closed', () => {
    renderScene({}, false);

    expect(
      screen.queryByRole('dialog', { name: 'Remove Puppet CA Proxy' })
    ).not.toBeInTheDocument();
  });

  it('shows the remove modal with warning for selected hosts when opened', async () => {
    renderScene();

    const dialog = await screen.findByRole('dialog', {
      name: 'Remove Puppet CA Proxy',
    });

    expect(dialog).toBeInTheDocument();
    expect(
      within(dialog).getByText(/Removing the Puppet CA proxy will affect/)
    ).toBeInTheDocument();
    expect(within(dialog).getByText('2', { selector: 'strong' })).toBeInTheDocument();
    expect(within(dialog).getByText(/selected hosts/)).toBeInTheDocument();
    expect(
      within(dialog).getByText(
        /Warning: If a Puppet Proxy is still set, the Puppet CA Proxy will fall back to that value after removal!/
      )
    ).toBeInTheDocument();
    expect(
      within(dialog).getByRole('button', { name: 'Remove Puppet CA Proxy' })
    ).toBeInTheDocument();
    expect(
      within(dialog).getByRole('button', { name: 'Cancel' })
    ).toBeInTheDocument();
  });

  it('shows all hosts warning message when select all hosts mode is enabled', async () => {
    renderScene({ selectAllHostsMode: true });

    const dialog = await screen.findByRole('dialog', {
      name: 'Remove Puppet CA Proxy',
    });

    expect(
      within(dialog).getByText(/Removing the Puppet CA proxy will affect/)
    ).toBeInTheDocument();
    expect(within(dialog).getByText('All', { selector: 'strong' })).toBeInTheDocument();
    expect(within(dialog).getByText(/selected hosts/)).toBeInTheDocument();
    expect(
      within(dialog).getByText(
        /Warning: If a Puppet Proxy is still set, the Puppet CA Proxy will fall back to that value after removal!/
      )
    ).toBeInTheDocument();
  });

  it('closes the modal when cancel is clicked', async () => {
    renderScene();

    await screen.findByRole('dialog', { name: 'Remove Puppet CA Proxy' });
    await userEvent.click(screen.getByRole('button', { name: 'Cancel' }));

    expect(
      screen.queryByRole('dialog', { name: 'Remove Puppet CA Proxy' })
    ).not.toBeInTheDocument();
  });

  it('submits CA proxy removal request when confirm is clicked', async () => {
    renderScene();

    await screen.findByRole('dialog', { name: 'Remove Puppet CA Proxy' });
    await act(async () => {
      await userEvent.click(
        screen.getByRole('button', { name: 'Remove Puppet CA Proxy' })
      );
    });

    expect(fetchBulkParams).toHaveBeenCalledTimes(1);
    expect(APIActions.put).toHaveBeenCalledWith(
      expect.objectContaining({
        key: BULK_REMOVE_PUPPET_CA_PROXY_KEY,
        params: {
          included: {
            search: 'id ^ (1,2)',
          },
          ca_proxy: true,
        },
      })
    );
  });

  it('refreshes table data after successful removal', async () => {
    API.put.mockImplementation(() =>
      Promise.resolve({ data: { message: 'Removal started' } })
    );

    renderScene();

    await screen.findByRole('dialog', { name: 'Remove Puppet CA Proxy' });
    await act(async () => {
      await userEvent.click(
        screen.getByRole('button', { name: 'Remove Puppet CA Proxy' })
      );
    });

    await waitFor(() => {
      expect(refreshTableData).toHaveBeenCalledTimes(1);
    });
    expect(
      screen.queryByRole('dialog', { name: 'Remove Puppet CA Proxy' })
    ).not.toBeInTheDocument();
  });
});
