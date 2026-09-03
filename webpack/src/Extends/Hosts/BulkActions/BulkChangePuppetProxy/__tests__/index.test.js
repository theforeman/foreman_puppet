import React from 'react';
import { act, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import '@testing-library/jest-dom';

import { openBulkModal } from 'foremanReact/common/BulkModalStateHelper';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';
import { rtlHelpers } from 'foremanReact/common/rtlTestHelpers';
import { APIActions } from 'foremanReact/redux/API';
import API from 'foremanReact/redux/API/API';

import BulkChangePuppetProxyScene from '../index';
import { BULK_CHANGE_PUPPET_PROXY_KEY } from '../../BulkChangeProxyCommon/actions';

jest.mock('foremanReact/redux/API', () => {
  const actual = jest.requireActual('foremanReact/redux/API');

  return {
    ...actual,
    APIActions: {
      ...actual.APIActions,
      put: jest.fn(params => ({ type: 'MOCK_API_PUT', payload: params })),
    },
  };
});

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

const selectPuppetProxy = async () => {
  await act(async () => {
    await userEvent.click(await screen.findByText('Select a Puppet Proxy'));
  });
  await act(async () => {
    await userEvent.click(screen.getByText('proxy1.example.com'));
  });
};

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

  it('submits puppet proxy change request when confirm is clicked', async () => {
    openBulkModal(MODAL_ID, true);
    renderScene();

    await screen.findByRole('dialog', { name: 'Change Puppet Proxy' });
    await selectPuppetProxy();
    await act(async () => {
      await userEvent.click(
        screen.getByRole('button', { name: 'Change Puppet Proxy' })
      );
    });

    expect(fetchBulkParams).toHaveBeenCalledTimes(1);
    expect(APIActions.put).toHaveBeenCalledWith(
      expect.objectContaining({
        key: BULK_CHANGE_PUPPET_PROXY_KEY,
        params: {
          included: {
            search: 'id ^ (1,2)',
          },
          proxy_id: '1',
          ca_proxy: false,
        },
      })
    );
  });

  it('refreshes table data after successful change', async () => {
    openBulkModal(MODAL_ID, true);
    renderScene();

    await screen.findByRole('dialog', { name: 'Change Puppet Proxy' });
    await selectPuppetProxy();
    await act(async () => {
      await userEvent.click(
        screen.getByRole('button', { name: 'Change Puppet Proxy' })
      );
    });

    const { handleSuccess } = APIActions.put.mock.calls[0][0];

    act(() => {
      handleSuccess({ data: { message: 'Change started' } });
    });

    expect(refreshTableData).toHaveBeenCalledTimes(1);
    expect(
      screen.queryByRole('dialog', { name: 'Change Puppet Proxy' })
    ).not.toBeInTheDocument();
  });
});
