import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import '@testing-library/jest-dom';
import { IntlProvider } from 'react-intl';
import { useDispatch, useSelector } from 'react-redux';

import BulkChangePuppetEnvironmentModal from '../BulkChangePuppetEnvironmentModal';
import {
  fetchEnvironments,
  bulkChangePuppetEnvironment,
} from '../actions';
import {
  selectAPIResponse,
  selectAPIStatus,
} from 'foremanReact/redux/API/APISelectors';

jest.mock('@patternfly/react-core', () => {
  const React = require('react');
  const actual = jest.requireActual('@patternfly/react-core');

  const MenuToggle = React.forwardRef(({ children, onClick }, ref) => (
    <button type="button" ref={ref} onClick={onClick}>
      {children}
    </button>
  ));

  const SelectOption = ({ children, value, onSelect }) => (
    <button type="button" onClick={event => onSelect(event, value)}>
      {children}
    </button>
  );

  const SelectList = ({ children, onSelect }) => (
    <div>
      {React.Children.map(children, child =>
        React.isValidElement(child) ? React.cloneElement(child, { onSelect }) : child
      )}
    </div>
  );

  const Select = ({ children, isOpen, toggle, onSelect }) => (
    <div>
      {toggle()}
      {isOpen &&
        React.Children.map(children, child =>
          React.isValidElement(child)
            ? React.cloneElement(child, { onSelect })
            : child
        )}
    </div>
  );

  return {
    ...actual,
    MenuToggle,
    Select,
    SelectList,
    SelectOption,
  };
});

jest.mock('react-redux', () => ({
  ...jest.requireActual('react-redux'),
  useDispatch: jest.fn(),
  useSelector: jest.fn(),
}));

jest.mock('foremanReact/Root/Context/ForemanContext', () => ({
  useForemanOrganization: jest.fn(() => ({ id: 23 })),
}));

jest.mock('foremanReact/redux/API/APISelectors', () => ({
  selectAPIResponse: jest.fn(),
  selectAPIStatus: jest.fn(),
}));

jest.mock('../actions', () => ({
  fetchEnvironments: jest.fn(() => ({ type: 'FETCH_ENVIRONMENTS' })),
  bulkChangePuppetEnvironment: jest.fn(() => ({
    type: 'BULK_CHANGE_PUPPET_ENVIRONMENT',
  })),
  PUPPET_ENVIRONMENTS_KEY: 'PUPPET_ENVIRONMENTS_KEY',
  BULK_CHANGE_PUPPET_ENVIRONMENT_KEY: 'BULK_CHANGE_PUPPET_ENVIRONMENT',
  INHERIT_ENVIRONMENT: 'inherit',
}));

describe('BulkChangePuppetEnvironmentModal', () => {
  const dispatch = jest.fn();
  const fetchBulkParams = jest.fn(() => 'organization = "Default Organization"');
  const environmentsResponse = {
    results: [{ id: 1, name: 'production' }],
  };

  const renderComponent = () =>
    render(
      <IntlProvider locale="en">
        <BulkChangePuppetEnvironmentModal
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
    selectAPIResponse.mockReturnValue(environmentsResponse);
    selectAPIStatus.mockReturnValue('RESOLVED');
    useSelector.mockImplementation(selector => selector({}));
  });

  it('renders the environment options', () => {
    renderComponent();

    expect(fetchEnvironments).toHaveBeenCalled();
    expect(screen.getAllByText('Change Puppet Environment')[0]).toBeInTheDocument();
    expect(
      screen.getByRole('button', { name: 'Select an Environment' })
    ).toBeInTheDocument();
    expect(
      screen.getByText(/Changing the Puppet environment will affect/)
    ).toBeInTheDocument();
  });

  it('submits organization scope with the bulk change request', () => {
    renderComponent();

    fireEvent.click(screen.getByRole('button', { name: 'Select an Environment' }));
    expect(screen.getByText('*Inherit from host group*')).toBeInTheDocument();
    fireEvent.click(screen.getByText('production'));
    fireEvent.click(
      screen.getByRole('button', { name: 'Change Puppet Environment' })
    );

    expect(bulkChangePuppetEnvironment).toHaveBeenCalledWith(
      {
        included: {
          search: 'organization = "Default Organization"',
        },
        environment_id: '1',
        organization_id: 23,
      },
      expect.any(Function),
      expect.any(Function)
    );
  });
});
