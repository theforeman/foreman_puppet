import React from 'react';
import { screen, act } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import '@testing-library/jest-dom';

import { openBulkModal } from 'foremanReact/common/BulkModalStateHelper';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';
import { rtlHelpers } from 'foremanReact/common/rtlTestHelpers';
import { APIActions } from 'foremanReact/redux/API';
import { foremanUrl } from 'foremanReact/common/helpers';

import BulkRemovePuppetProxyScene from '../index';
import { BULK_REMOVE_PUPPET_PROXY_KEY } from '../../BulkRemoveProxyCommon/actions';

jest.mock(
  'foremanReact/components/HostDetails/ActionsBar',
  () => ({
    ForemanActionsBarContext: jest.requireActual('react').createContext(),
  }),
  { virtual: true }
);

jest.mock('foremanReact/redux/API', () => ({
  APIActions: {
    put: jest.fn(payload => ({ type: 'MOCK_API_PUT', payload })),
  },
}));

const { renderWithStoreAndI18n } = rtlHelpers;

describe('BulkRemovePuppetProxyScene', () => {
  const fetchBulkParams = jest.fn(() => 'name = host1');
  const refreshTableData = jest.fn();
  const contextValue = {
    selectAllHostsMode: false,
    selectedCount: 2,
    selectedResults: [1, 2],
    fetchBulkParams,
    refreshTableData,
  };

  const renderScene = (context = contextValue) =>
    renderWithStoreAndI18n(
      <ForemanActionsBarContext.Provider value={context}>
        <BulkRemovePuppetProxyScene />
      </ForemanActionsBarContext.Provider>
    );

  const openSceneModal = async () => {
    openBulkModal('bulk-remove-puppet-proxy', true);

    return screen.findByRole('dialog', { name: 'Remove Puppet Proxy' });
  };

  beforeEach(() => {
    openBulkModal('bulk-remove-puppet-proxy', false);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('does not show the modal when bulk modal state is closed', () => {
    renderScene();

    expect(
      screen.queryByRole('dialog', { name: 'Remove Puppet Proxy' })
    ).not.toBeInTheDocument();
  });

  it('shows the modal with a warning for the selected hosts when opened', async () => {
    renderScene();
    await openSceneModal();

    expect(
      screen.getByText(/Removing the Puppet proxy will affect/)
    ).toBeInTheDocument();
    expect(screen.getByText('2', { selector: 'strong' })).toBeInTheDocument();
    expect(screen.getByText(/selected hosts/)).toBeInTheDocument();
    expect(
      screen.getByRole('button', { name: 'Remove Puppet Proxy' })
    ).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Cancel' })).toBeInTheDocument();
  });

  it('shows the all hosts warning when select all hosts mode is enabled', async () => {
    renderScene({
      ...contextValue,
      selectAllHostsMode: true,
    });
    await openSceneModal();

    expect(
      screen.getByText(/Removing the Puppet proxy will affect/)
    ).toBeInTheDocument();
    expect(screen.getByText('All', { selector: 'strong' })).toBeInTheDocument();
    expect(screen.getByText(/selected hosts/)).toBeInTheDocument();
  });

  it('closes the modal when Cancel is clicked', async () => {
    renderScene();
    await openSceneModal();

    await userEvent.click(screen.getByRole('button', { name: 'Cancel' }));

    expect(
      screen.queryByRole('dialog', { name: 'Remove Puppet Proxy' })
    ).not.toBeInTheDocument();
  });

  it('dispatches the bulk remove puppet proxy action when confirmed', async () => {
    renderScene();
    await openSceneModal();

    await userEvent.click(
      screen.getByRole('button', { name: 'Remove Puppet Proxy' })
    );

    expect(fetchBulkParams).toHaveBeenCalledTimes(1);
    expect(APIActions.put).toHaveBeenCalledWith({
      key: BULK_REMOVE_PUPPET_PROXY_KEY,
      url: foremanUrl('/api/v2/hosts/bulk/remove_puppet_proxy'),
      handleSuccess: expect.any(Function),
      handleError: expect.any(Function),
      params: {
        included: {
          search: 'name = host1',
        },
        ca_proxy: false,
      },
    });
  });

  it('refreshes table data after a successful bulk remove', async () => {
    renderScene();
    await openSceneModal();

    await userEvent.click(
      screen.getByRole('button', { name: 'Remove Puppet Proxy' })
    );

    const { handleSuccess } = APIActions.put.mock.calls[0][0];

    act(() => {
      handleSuccess({ data: { message: 'Puppet proxy removed' } });
    });

    expect(refreshTableData).toHaveBeenCalledTimes(1);
    expect(
      screen.queryByRole('dialog', { name: 'Remove Puppet Proxy' })
    ).not.toBeInTheDocument();
  });
});
