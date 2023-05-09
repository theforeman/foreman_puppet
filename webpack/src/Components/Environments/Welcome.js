import React from 'react';
import PropTypes from 'prop-types';
import { FormattedMessage } from 'react-intl';
import { translate as __ } from 'foremanReact/common/I18n';
import EmptyState from 'foremanReact/components/common/EmptyState';
import { foremanUrl, getManualURL } from 'foremanReact/common/helpers';

export const WelcomeEnv = ({ canCreate }) => {
  const action = canCreate && {
    title: __('Create Puppet Environment'),
    url: foremanUrl('/foreman_puppet/environments/new'),
  };

  const description = (
    <>
      <FormattedMessage
        id="puppetenv-welcome"
        defaultMessage={__(
          'If you are planning to use Foreman as an external node classifier you should provide information about one or more environments.{newLine}This information is commonly imported from a pre-existing Puppet configuration by the use of the {puppetClassesLinkToDocs} and environment importer.'
        )}
        values={{
          newLine: <br />,
          puppetClassesLinkToDocs: (
            <a
              target="_blank"
              href={getManualURL('4.2.2Classes')}
              rel="noreferrer"
            >
              {__('Puppet classes')}
            </a>
          ),
        }}
      />
    </>
  );
  return (
    <EmptyState
      icon="th"
      iconType="fa"
      header={__('Puppet Environments')}
      description={description}
      documentation={{ url: getManualURL('4.2.1Environments') }}
      action={action}
    />
  );
};

WelcomeEnv.propTypes = {
  canCreate: PropTypes.bool,
};

WelcomeEnv.defaultProps = {
  canCreate: false,
};

export default WelcomeEnv;
