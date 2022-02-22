import React from 'react';
import PropTypes from 'prop-types';
import { useHistory } from 'react-router-dom';
import { Tabs, Tab, TabTitleText } from '@patternfly/react-core';
import SecondaryTabRoutes from './Routes';
import { activeTab } from './helpers';
import { SECONDARY_TABS } from './constants';

const PuppetTab = ({ response, location: { pathname } }) => {
  const hashHistory = useHistory();
  return (
    <>
      <Tabs
        className="margin-0-24"
        onSelect={(evt, subTab) => hashHistory.push(subTab)}
        isSecondary
        activeKey={activeTab(pathname)}
      >
        {SECONDARY_TABS.map(({ key, title }) => (
          <Tab
            key={key}
            eventKey={key}
            title={<TabTitleText>{title}</TabTitleText>}
          />
        ))}
      </Tabs>
      <SecondaryTabRoutes hostName={response.name} />
    </>
  );
};

PuppetTab.propTypes = {
  response: PropTypes.object,
  location: PropTypes.shape({
    pathname: PropTypes.string,
  }),
};
PuppetTab.defaultProps = {
  location: { pathname: '' },
  response: { name: '' },
};

export default PuppetTab;
