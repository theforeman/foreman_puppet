import React from 'react';
import { addGlobalFill } from 'foremanReact/components/common/Fill/GlobalFill';
import { registerReducer } from 'foremanReact/common/MountingService';
import { registerColumns } from 'foremanReact/components/HostsIndex/Columns/core';
import { translate as __ } from 'foremanReact/common/I18n';
import reducers from './src/reducers';
import { registerFills } from './src/Extends/Fills';
import { registerLegacy } from './legacy';
import HostsIndexActionsBar from './src/Extends/Hosts/ActionsBar';
import BulkChangePuppetProxy from './src/Extends/Hosts/BulkActions/BulkChangePuppetProxy';
import BulkChangePuppetCAProxy from './src/Extends/Hosts/BulkActions/BulkChangePuppetCAProxy';
import BulkRemovePuppetProxy from './src/Extends/Hosts/BulkActions/BulkRemovePuppetProxy';
import BulkRemovePuppetCAProxy from './src/Extends/Hosts/BulkActions/BulkRemovePuppetCAProxy';

// register reducers
registerReducer('puppet', reducers);
// add fills
registerFills();
// TODO: the checkForUnavailablePuppetclasses is very nasty
registerLegacy();

// register columns for React hosts index page
const puppetHostsIndexColumns = [
  {
    columnName: 'environment',
    title: __('Puppet env'),
    isSorted: true,
    wrapper: hostDetails => hostDetails.environment_name,
    weight: 2700,
  },
];

puppetHostsIndexColumns.forEach(column => {
  column.tableName = 'hosts';
  column.categoryName = 'Puppet';
  column.categoryKey = 'puppet';
});

addGlobalFill(
  'hosts-index-kebab',
  'puppet-hosts-index-kebab',
  <HostsIndexActionsBar key="puppet-hosts-index-kebab" />,
  100
);

addGlobalFill(
  '_all-hosts-modals',
  'BulkChangePuppetProxy',
  <BulkChangePuppetProxy key="bulk-change-puppet-proxy" />,
  100
);

addGlobalFill(
  '_all-hosts-modals',
  'BulkChangePuppetCAProxy',
  <BulkChangePuppetCAProxy key="bulk-change-puppet-ca-proxy" />,
  100
);

addGlobalFill(
  '_all-hosts-modals',
  'BulkRemovePuppetCAProxy',
  <BulkRemovePuppetCAProxy key="bulk-remove-puppet-ca-proxy" />,
  100
);

addGlobalFill(
  '_all-hosts-modals',
  'BulkRemovePuppetProxy',
  <BulkRemovePuppetProxy key="bulk-remove-puppet-proxy" />,
  100
);

registerColumns(puppetHostsIndexColumns);
