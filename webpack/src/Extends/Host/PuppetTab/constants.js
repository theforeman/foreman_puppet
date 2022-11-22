import { translate as __ } from 'foremanReact/common/I18n';

export const SECONDARY_TABS = [
  { key: 'reports', title: __('Reports') },
  /** Hiding the two tabs since they were not implemented yet and shouldn't be part of the release.
   * { key: 'assigned', title: __('Assigned classes') },
   * { key: 'smart-classes', title: __('Smart class parameters') },
   */
  { key: 'yaml', title: __('ENC Preview') },
];
