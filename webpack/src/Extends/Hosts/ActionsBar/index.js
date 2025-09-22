import React, { useContext } from 'react';
import { Menu, MenuItem, MenuContent, MenuList } from '@patternfly/react-core';
import { translate as __ } from 'foremanReact/common/I18n';
import { ForemanHostsIndexActionsBarContext } from 'foremanReact/components/HostsIndex';
import { openBulkModal } from 'foremanReact/common/BulkModalStateHelper';
import './ActionsBar.scss';

const HostActionsBar = () => {
  const { selectedCount, setMenuOpen } = useContext(
    ForemanHostsIndexActionsBarContext
  );

  const handleOpenBulkModal = modalId => {
    setMenuOpen(false);
    setTimeout(() => openBulkModal(modalId, true), 0);
  };

  return (
    <MenuItem
      itemId="content-flyout-item"
      key="content-flyout"
      isDisabled={selectedCount === 0}
      flyoutMenu={
        <Menu ouiaId="content-flyout-menu" onSelect={() => setMenuOpen(false)}>
          <MenuContent>
            <MenuList>
              <MenuItem
                itemId="bulk-change-puppet-proxy-menu-item"
                key="bulk-change-puppet-proxy-menu-item"
                onClick={() => handleOpenBulkModal('bulk-change-puppet-proxy')}
                isDisabled={selectedCount === 0}
              >
                {__('Change Puppet proxy')}
              </MenuItem>
              <MenuItem
                itemId="bulk-remove-puppet-proxy-menu-item"
                key="bulk-remove-puppet-proxy-menu-item"
                onClick={() => handleOpenBulkModal('bulk-remove-puppet-proxy')}
                isDisabled={selectedCount === 0}
              >
                {__('Remove Puppet proxy')}
              </MenuItem>
              <MenuItem
                itemId="bulk-change-puppet-ca-proxy-menu-item"
                key="bulk-change-puppet-ca-proxy-menu-item"
                onClick={() =>
                  handleOpenBulkModal('bulk-change-puppet-ca-proxy')
                }
                isDisabled={selectedCount === 0}
              >
                {__('Change Puppet CA proxy')}
              </MenuItem>
              <MenuItem
                itemId="bulk-remove-puppet-ca-proxy-menu-item"
                key="bulk-remove-puppet-ca-proxy-menu-item"
                onClick={() =>
                  handleOpenBulkModal('bulk-remove-puppet-ca-proxy')
                }
                isDisabled={selectedCount === 0}
              >
                {__('Remove Puppet CA proxy')}
              </MenuItem>
            </MenuList>
          </MenuContent>
        </Menu>
      }
    >
      {__('Puppet')}
    </MenuItem>
  );
};

export default HostActionsBar;
