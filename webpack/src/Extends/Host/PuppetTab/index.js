import React from 'react';
import PropTypes from 'prop-types';
import { useHistory } from 'react-router-dom';
import { Tabs, Tab, TabTitleText } from '@patternfly/react-core';
import { STATUS } from 'foremanReact/constants';

import SecondaryTabRoutes from './Routes';
import { activeTab } from './helpers';
import { SECONDARY_TABS } from './constants';

import './styles.scss';

const PuppetTab = ({ response, status, location: { pathname } }) => {
  const hashHistory = useHistory();
  return (
    <>
      <Tabs
        ouiaId="foreman-puppet-host-details-tab"
        className="foreman-puppet-host-details-tab"
        onSelect={(evt, subTab) => hashHistory.push(subTab)}
        isSecondary
        activeKey={activeTab(pathname)}
      >
        {SECONDARY_TABS.map(({ key, title }) => (
          <Tab
            key={key}
            id={`puppet-subtab-${key}`}
            ouiaId={`puppet-subtab-${key}`}
            eventKey={key}
            title={<TabTitleText>{title}</TabTitleText>}
          />
        ))}
      </Tabs>
      <SecondaryTabRoutes
        hostName={response.name}
        hostInfo={response}
        status={status}
      />
    </>
  );
};

PuppetTab.propTypes = {
  response: PropTypes.object,
  status: PropTypes.string,
  location: PropTypes.shape({
    pathname: PropTypes.string,
  }),
};
PuppetTab.defaultProps = {
  location: { pathname: '' },
  response: { name: '' },
  status: STATUS.PENDING,
};

export default PuppetTab;
