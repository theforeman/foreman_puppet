import React from 'react';
import { translate as __ } from 'foremanReact/common/I18n';
import { addGlobalFill } from 'foremanReact/components/common/Fill/GlobalFill';
import PuppetTab from '../Host/PuppetTab';

const fills = [
  {
    slot: 'host-details-page-tabs',
    name: 'Puppet',
    component: props => <PuppetTab {...props} />,
    weight: 500,
    metadata: { title: __('Puppet') },
  },
];

export const registerFills = () => {
  fills.forEach(({ slot, name, component: Component, weight, metadata }) =>
    addGlobalFill(
      slot,
      name,
      <Component key={`puppet-fill-${name}`} />,
      weight,
      metadata
    )
  );
};
