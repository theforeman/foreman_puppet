import React, { useContext } from 'react';
import { translate as __ } from 'foremanReact/common/I18n';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';
import { useBulkModalOpen } from 'foremanReact/common/BulkModalStateHelper';

import BulkChangeProxyCommon from '../BulkChangeProxyCommon';

const BulkChangePuppetCAProxyScene = () => {
  const {
    selectAllHostsMode,
    selectedCount,
    selectedResults,
    fetchBulkParams,
  } = useContext(ForemanActionsBarContext);
  const { isOpen, close: closeModal } = useBulkModalOpen(
    'bulk-change-puppet-ca-proxy'
  );
  return (
    <BulkChangeProxyCommon
      isCAProxy
      fetchBulkParams={fetchBulkParams}
      selectedCount={selectedCount}
      selectedResults={selectedResults}
      selectAllHostsMode={selectAllHostsMode}
      isOpen={isOpen}
      closeModal={closeModal}
      selectMessage={__('Select a Puppet CA Proxy')}
      handleErrorMessage={__('Failed to change Puppet CA Proxy')}
      changeMessage={__('Change Puppet CA Proxy')}
      allHostsMessage={__(
        'Changing the Puppet CA proxy will affect {boldCount} selected hosts. Some hosts may already have been associated with the selected Puppet CA proxy.'
      )}
      someHostsMessage={__(
        'Changing the Puppet CA proxy will affect {boldCount} selected {count, plural, one {host} other {hosts}}. Some hosts may already have been associated with the selected Puppet CA proxy.'
      )}
    />
  );
};

export default BulkChangePuppetCAProxyScene;
