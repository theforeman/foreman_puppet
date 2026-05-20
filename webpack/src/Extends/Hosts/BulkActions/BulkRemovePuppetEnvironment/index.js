import React, { useContext } from 'react';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';
import { useBulkModalOpen } from 'foremanReact/common/BulkModalStateHelper';
import BulkRemovePuppetEnvironmentModal from './BulkRemovePuppetEnvironmentModal';

const BulkRemovePuppetEnvironmentScene = () => {
  const { selectAllHostsMode, selectedCount, fetchBulkParams } = useContext(
    ForemanActionsBarContext
  );
  const { isOpen, close: closeModal } = useBulkModalOpen(
    'bulk-remove-puppet-environment'
  );

  return (
    <BulkRemovePuppetEnvironmentModal
      fetchBulkParams={fetchBulkParams}
      selectedCount={selectedCount}
      selectAllHostsMode={selectAllHostsMode}
      isOpen={isOpen}
      closeModal={closeModal}
    />
  );
};

export { BulkRemovePuppetEnvironmentModal };
export default BulkRemovePuppetEnvironmentScene;
