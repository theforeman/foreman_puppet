import React, { useContext } from 'react';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';
import { useBulkModalOpen } from 'foremanReact/common/BulkModalStateHelper';
import { translate as __ } from 'foremanReact/common/I18n';
import BulkRemoveProxyCommon from '../BulkRemoveProxyCommon';

const BulkRemovePuppetCAProxyScene = () => {
  const {
    selectAllHostsMode,
    selectedCount,
    selectedResults,
    fetchBulkParams,
  } = useContext(ForemanActionsBarContext);
  const { isOpen, close: closeModal } = useBulkModalOpen(
    'bulk-remove-puppet-ca-proxy'
  );
  return (
    <BulkRemoveProxyCommon
      isCAProxy
      key="bulk-remove-puppet-ca-proxy"
      selectAllHostsMode={selectAllHostsMode}
      selectedCount={selectedCount}
      selectedResults={selectedResults}
      fetchBulkParams={fetchBulkParams}
      isOpen={isOpen}
      closeModal={closeModal}
      handleErrorMessage={__('Failed to remove Puppet CA Proxy')}
      allHostsMessage={__(
        'Removing the Puppet CA proxy will affect {boldCount} selected hosts. Warning: If a Puppet Proxy is still set, the Puppet CA Proxy will fall back to that value after removal!'
      )}
      someHostsMessage={__(
        'Removing the Puppet CA proxy will affect {boldCount} selected {count, plural, one {host} other {hosts}}. Warning: If a Puppet Proxy is still set, the Puppet CA Proxy will fall back to that value after removal!'
      )}
      removeMessage={__('Remove Puppet CA Proxy')}
    />
  );
};

export default BulkRemovePuppetCAProxyScene;
