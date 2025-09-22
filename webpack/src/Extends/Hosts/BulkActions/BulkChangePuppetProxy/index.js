import React, { useContext } from 'react';
import { ForemanActionsBarContext } from 'foremanReact/components/HostDetails/ActionsBar';
import { useBulkModalOpen } from 'foremanReact/common/BulkModalStateHelper';
import { translate as __ } from 'foremanReact/common/I18n';

import BulkChangeProxyCommon from '../BulkChangeProxyCommon';

const BulkChangePuppetProxyScene = () => {
  const {
    selectAllHostsMode,
    selectedCount,
    selectedResults,
    fetchBulkParams,
  } = useContext(ForemanActionsBarContext);
  const { isOpen, close: closeModal } = useBulkModalOpen(
    'bulk-change-puppet-proxy'
  );
  return (
    <BulkChangeProxyCommon
      isCAProxy={false}
      fetchBulkParams={fetchBulkParams}
      selectedCount={selectedCount}
      selectedResults={selectedResults}
      selectAllHostsMode={selectAllHostsMode}
      isOpen={isOpen}
      closeModal={closeModal}
      selectMessage={__('Select a Puppet Proxy')}
      handleErrorMessage={__('Failed to change Puppet Proxy')}
      changeMessage={__('Change Puppet Proxy')}
      allHostsMessage={__(
        'Changing the Puppet proxy will affect {boldCount} selected hosts. Some hosts may already have been associated with the selected Puppet proxy.'
      )}
      someHostsMessage={__(
        'Changing the Puppet proxy will affect {boldCount} selected {count, plural, one {host} other {hosts}}. Some hosts may already have been associated with the selected Puppet proxy.'
      )}
    />
  );
};

export default BulkChangePuppetProxyScene;
