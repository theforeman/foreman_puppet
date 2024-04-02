import { registerReducer } from 'foremanReact/common/MountingService';
import { registerColumns } from 'foremanReact/components/HostsIndex/Columns/core';
import { translate as __ } from 'foremanReact/common/I18n';
import reducers from './src/reducers';
import { registerFills } from './src/Extends/Fills';
import { registerLegacy } from './legacy';

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

registerColumns(puppetHostsIndexColumns);
