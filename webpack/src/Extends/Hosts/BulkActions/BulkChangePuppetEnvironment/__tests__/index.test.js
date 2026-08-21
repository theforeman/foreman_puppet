import React from 'react';
import renderer, { act } from 'react-test-renderer';

import { useBulkModalOpen } from 'foremanReact/common/BulkModalStateHelper';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';

import BulkChangePuppetEnvironmentScene from '../index';
import BulkChangePuppetEnvironmentModal from '../BulkChangePuppetEnvironmentModal';

jest.mock('foremanReact/common/BulkModalStateHelper', () => ({
  useBulkModalOpen: jest.fn(),
}));

jest.mock('../BulkChangePuppetEnvironmentModal', () => ({
  __esModule: true,
  default: jest.fn(() => null),
}));

describe('BulkChangePuppetEnvironmentScene', () => {
  const fetchBulkParams = jest.fn();
  const contextValue = {
    selectAllHostsMode: false,
    selectedCount: 2,
    selectedResults: [1, 2],
    fetchBulkParams,
  };

  beforeEach(() => {
    jest.clearAllMocks();
    useBulkModalOpen.mockReturnValue({
      isOpen: true,
      close: jest.fn(),
    });
  });

  it('opens with bulk modal state and passes expected props', () => {
    let component;
    act(() => {
      component = renderer.create(
        <ForemanActionsBarContext.Provider value={contextValue}>
          <BulkChangePuppetEnvironmentScene />
        </ForemanActionsBarContext.Provider>
      );
    });

    const componentType =
      BulkChangePuppetEnvironmentModal.default ||
      BulkChangePuppetEnvironmentModal;
    const { props } = component.root.findByType(componentType);

    expect(props).toEqual(
      expect.objectContaining({
        fetchBulkParams,
        selectedCount: 2,
        selectAllHostsMode: false,
        isOpen: true,
        closeModal: expect.any(Function),
      })
    );

    component.unmount();
  });
});
