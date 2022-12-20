import PropTypes from 'prop-types';
import React from 'react';
import {
  Card,
  CardBody,
  CardHeader,
  CardTitle,
  CardExpandableContent,
  DescriptionList,
  DescriptionListTerm,
  DescriptionListGroup,
  DescriptionListDescription,
} from '@patternfly/react-core';
import SkeletonLoader from 'foremanReact/components/common/SkeletonLoader';
import DefaultLoaderEmptyState from 'foremanReact/components/HostDetails/DetailsCard/DefaultLoaderEmptyState';
import { STATUS } from 'foremanReact/constants';
import { translate as __ } from 'foremanReact/common/I18n';

const DescriptionCard = ({
  proxyName,
  caProxy,
  proxyId,
  caProxyId,
  env,
  status,
}) => {
  const [isExpanded, setIsExpanded] = React.useState(false);
  return (
    <Card isExpanded={isExpanded} ouiaId="card-template">
      <CardHeader onExpand={() => setIsExpanded(v => !v)}>
        <CardTitle id="expandable-card-title">{__('Puppet details')}</CardTitle>
      </CardHeader>
      <CardExpandableContent>
        <CardBody>
          <DescriptionList isCompact>
            <DescriptionListGroup>
              <DescriptionListTerm>
                {__('Puppet environment')}
              </DescriptionListTerm>
              <DescriptionListDescription>
                <SkeletonLoader
                  emptyState={<DefaultLoaderEmptyState />}
                  status={status}
                >
                  {env && (
                    <a
                      href={`/foreman_puppet/environments/?search=name+%3D+${env}`}
                    >
                      {env}
                    </a>
                  )}
                </SkeletonLoader>
              </DescriptionListDescription>
            </DescriptionListGroup>
            <DescriptionListGroup>
              <DescriptionListTerm>
                {__('Puppet Smart Proxy')}
              </DescriptionListTerm>
              <DescriptionListDescription>
                <SkeletonLoader
                  emptyState={<DefaultLoaderEmptyState />}
                  status={status}
                >
                  {proxyName && (
                    <a href={`/smart_proxies/${proxyId}#puppet`}>{proxyName}</a>
                  )}
                </SkeletonLoader>
              </DescriptionListDescription>
            </DescriptionListGroup>
            <DescriptionListGroup>
              <DescriptionListTerm>
                {__('Puppet CA Smart Proxy')}
              </DescriptionListTerm>
              <DescriptionListDescription>
                <SkeletonLoader
                  emptyState={<DefaultLoaderEmptyState />}
                  status={status}
                >
                  {caProxy && (
                    <a href={`/smart_proxies/${caProxyId}#puppet-ca`}>
                      {caProxy}
                    </a>
                  )}
                </SkeletonLoader>
              </DescriptionListDescription>
            </DescriptionListGroup>
          </DescriptionList>
        </CardBody>
      </CardExpandableContent>
    </Card>
  );
};

DescriptionCard.propTypes = {
  caProxy: PropTypes.string,
  caProxyId: PropTypes.number,
  env: PropTypes.string,
  proxyId: PropTypes.number,
  proxyName: PropTypes.string,
  status: PropTypes.string,
};

DescriptionCard.defaultProps = {
  caProxy: undefined,
  caProxyId: undefined,
  env: undefined,
  proxyId: undefined,
  proxyName: undefined,
  status: STATUS.PENDING,
};

export default DescriptionCard;
