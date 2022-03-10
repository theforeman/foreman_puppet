import PropTypes from 'prop-types';
import React from 'react';
import CardTemplate from 'foremanReact/components/HostDetails/Templates/CardItem/CardTemplate';
import {
  DescriptionList,
  DescriptionListTerm,
  DescriptionListGroup,
  DescriptionListDescription,
} from '@patternfly/react-core';
import SkeletonLoader from 'foremanReact/components/common/SkeletonLoader';
import DefaultLoaderEmptyState from 'foremanReact/components/HostDetails/DetailsCard/DefaultLoaderEmptyState';
import { STATUS } from 'foremanReact/constants';
import { translate as __ } from 'foremanReact/common/I18n';

const DescriptionCard = ({ proxyName, caProxy, env, status }) => (
  <CardTemplate header={__('Puppet details')} expandable>
    <DescriptionList isCompact>
      <DescriptionListGroup>
        <DescriptionListTerm>{__('Puppet environment')}</DescriptionListTerm>
        <DescriptionListDescription>
          <SkeletonLoader
            emptyState={<DefaultLoaderEmptyState />}
            status={status}
          >
            {env && (
              <a href={`/foreman_puppet/environments/${env}/edit`}>{env}</a>
            )}
          </SkeletonLoader>
        </DescriptionListDescription>
      </DescriptionListGroup>
      <DescriptionListGroup>
        <DescriptionListTerm>{__('Puppet smart proxy')}</DescriptionListTerm>
        <DescriptionListDescription>
          <SkeletonLoader
            emptyState={<DefaultLoaderEmptyState />}
            status={status}
          >
            {proxyName}
          </SkeletonLoader>
        </DescriptionListDescription>
      </DescriptionListGroup>
      <DescriptionListGroup>
        <DescriptionListTerm>{__('Puppet server CA')}</DescriptionListTerm>
        <DescriptionListDescription>
          <SkeletonLoader
            emptyState={<DefaultLoaderEmptyState />}
            status={status}
          >
            {caProxy}
          </SkeletonLoader>
        </DescriptionListDescription>
      </DescriptionListGroup>
    </DescriptionList>
  </CardTemplate>
);

DescriptionCard.propTypes = {
  caProxy: PropTypes.string,
  env: PropTypes.string,
  proxyName: PropTypes.string,
  status: PropTypes.string,
};

DescriptionCard.defaultProps = {
  caProxy: undefined,
  env: undefined,
  proxyName: undefined,
  status: STATUS.PENDING,
};

export default DescriptionCard;
