import React, { useContext } from 'react';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';
import { useBulkModalOpen } from 'foremanReact/common/BulkModalStateHelper';
import BulkChangePuppetEnvironmentModal from './BulkChangePuppetEnvironmentModal';

const BulkChangePuppetEnvironmentScene = () => {
  const { selectAllHostsMode, selectedCount, fetchBulkParams } = useContext(
    ForemanActionsBarContext
  );
  const { isOpen, close: closeModal } = useBulkModalOpen(
    'bulk-change-puppet-environment'
  );

  return (
    <BulkChangePuppetEnvironmentModal
      fetchBulkParams={fetchBulkParams}
      selectedCount={selectedCount}
      selectAllHostsMode={selectAllHostsMode}
      isOpen={isOpen}
      closeModal={closeModal}
    />
  );
};

export { BulkChangePuppetEnvironmentModal };
export default BulkChangePuppetEnvironmentScene;
