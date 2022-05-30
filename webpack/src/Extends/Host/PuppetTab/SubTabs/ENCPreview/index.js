import React from 'react';
import { useAPI } from 'foremanReact/common/hooks/API/APIHooks';
import PropTypes from 'prop-types';

import Skeleton from 'react-loading-skeleton';
import EmptyState from 'foremanReact/components/common/EmptyState/EmptyStatePattern';
import { STATUS } from 'foremanReact/constants';
import { EmptyStateIcon } from '@patternfly/react-core';
import { ExclamationCircleIcon } from '@patternfly/react-icons';
import { global_danger_color_200 as dangerColor } from '@patternfly/react-tokens';
import { translate as __ } from 'foremanReact/common/I18n';
import { ENCTab } from './ENCTab';

const ENCPreview = ({ hostName }) => {
  const options = {
    params: { name: hostName, format: 'yml' },
    key: 'PUPPET_ENC_PREVIEW',
  };
  const url = `${window.location.origin.toString()}/foreman_puppet/hosts/${hostName}/externalNodes`;
  const { response, status } = useAPI('get', url, options);

  if (status === STATUS.PENDING) {
    return <Skeleton count={5} />;
  }

  if (status === STATUS.ERROR) {
    const icon = (
      <EmptyStateIcon icon={ExclamationCircleIcon} color={dangerColor.value} />
    );
    return (
      <EmptyState
        header={__('Error!')}
        icon={icon}
        description={response?.response?.data?.message}
      />
    );
  }
  if (response !== '' || response !== undefined) {
    return (
      <div className="yaml-tab" padding="16px 24px">
        <ENCTab encData={response} />
      </div>
    );
  }

  return null;
};

ENCPreview.propTypes = {
  hostName: PropTypes.string.isRequired,
};

export default ENCPreview;
