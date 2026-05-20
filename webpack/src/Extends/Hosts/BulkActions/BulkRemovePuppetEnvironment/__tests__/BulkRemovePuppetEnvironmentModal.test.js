import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import '@testing-library/jest-dom';
import { IntlProvider } from 'react-intl';
import { useDispatch } from 'react-redux';

import BulkRemovePuppetEnvironmentModal from '../BulkRemovePuppetEnvironmentModal';
import { bulkChangePuppetEnvironment } from '../../BulkChangePuppetEnvironment/actions';

jest.mock('react-redux', () => ({
  ...jest.requireActual('react-redux'),
  useDispatch: jest.fn(),
}));

jest.mock('foremanReact/Root/Context/ForemanContext', () => ({
  useForemanOrganization: jest.fn(() => ({ id: 23 })),
}));

jest.mock('../../BulkChangePuppetEnvironment/actions', () => ({
  bulkChangePuppetEnvironment: jest.fn(() => ({
    type: 'BULK_CHANGE_PUPPET_ENVIRONMENT',
  })),
  BULK_CHANGE_PUPPET_ENVIRONMENT_KEY: 'BULK_CHANGE_PUPPET_ENVIRONMENT',
}));

describe('BulkRemovePuppetEnvironmentModal', () => {
  const dispatch = jest.fn();

  const renderComponent = (fetchBulkParams = jest.fn()) =>
    render(
      <IntlProvider locale="en">
        <BulkRemovePuppetEnvironmentModal
          isOpen
          closeModal={jest.fn()}
          fetchBulkParams={fetchBulkParams}
          selectedCount={2}
          selectAllHostsMode={false}
        />
      </IntlProvider>
    );

  beforeEach(() => {
    jest.clearAllMocks();
    useDispatch.mockReturnValue(dispatch);
  });

  it('renders the removal warning', () => {
    renderComponent();

    expect(screen.getAllByText('Remove Puppet Environment')[0]).toBeInTheDocument();
    expect(
      screen.getByText(/Removing the Puppet environment will affect/)
    ).toBeInTheDocument();
  });

  it('submits organization scope with the bulk remove request', () => {
    const fetchBulkParams = jest.fn(() => 'organization = "Default Organization"');
    renderComponent(fetchBulkParams);

    fireEvent.click(
      screen.getByRole('button', { name: 'Remove Puppet Environment' })
    );

    expect(bulkChangePuppetEnvironment).toHaveBeenCalledWith(
      {
        included: {
          search: 'organization = "Default Organization"',
        },
        environment_id: null,
        organization_id: 23,
      },
      expect.any(Function),
      expect.any(Function)
    );
  });
});
