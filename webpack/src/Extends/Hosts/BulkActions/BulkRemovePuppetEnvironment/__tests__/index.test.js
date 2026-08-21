import React from 'react';
import renderer, { act } from 'react-test-renderer';

import { useBulkModalOpen } from 'foremanReact/common/BulkModalStateHelper';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';

import BulkRemovePuppetEnvironmentScene from '../index';
import BulkRemovePuppetEnvironmentModal from '../BulkRemovePuppetEnvironmentModal';

jest.mock('foremanReact/common/BulkModalStateHelper', () => ({
  useBulkModalOpen: jest.fn(),
}));

jest.mock('../BulkRemovePuppetEnvironmentModal', () => ({
  __esModule: true,
  default: jest.fn(() => null),
}));

describe('BulkRemovePuppetEnvironmentScene', () => {
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
          <BulkRemovePuppetEnvironmentScene />
        </ForemanActionsBarContext.Provider>
      );
    });

    const componentType =
      BulkRemovePuppetEnvironmentModal.default ||
      BulkRemovePuppetEnvironmentModal;
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
