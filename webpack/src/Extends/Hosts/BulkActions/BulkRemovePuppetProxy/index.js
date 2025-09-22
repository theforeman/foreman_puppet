import React, { useContext } from 'react';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';
import { useBulkModalOpen } from 'foremanReact/common/BulkModalStateHelper';
import { translate as __ } from 'foremanReact/common/I18n';
import BulkRemoveProxyCommon from '../BulkRemoveProxyCommon';

const BulkRemovePuppetProxyScene = () => {
  const {
    selectAllHostsMode,
    selectedCount,
    selectedResults,
    fetchBulkParams,
  } = useContext(ForemanActionsBarContext);
  const { isOpen, close: closeModal } = useBulkModalOpen(
    'bulk-remove-puppet-proxy'
  );
  return (
    <BulkRemoveProxyCommon
      isCAProxy={false}
      key="bulk-remove-puppet-proxy"
      selectAllHostsMode={selectAllHostsMode}
      selectedCount={selectedCount}
      selectedResults={selectedResults}
      fetchBulkParams={fetchBulkParams}
      isOpen={isOpen}
      closeModal={closeModal}
      handleErrorMessage={__('Failed to remove Puppet Proxy')}
      allHostsMessage={__(
        'Removing the Puppet proxy will affect {boldCount} selected hosts.'
      )}
      someHostsMessage={__(
        'Removing the Puppet proxy will affect {boldCount} selected {count, plural, one {host} other {hosts}}.'
      )}
      removeMessage={__('Remove Puppet Proxy')}
    />
  );
};

export default BulkRemovePuppetProxyScene;
