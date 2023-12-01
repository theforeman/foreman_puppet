import PropTypes from 'prop-types';
import React from 'react';
import { Route, Switch, Redirect } from 'react-router-dom';
import { route } from './helpers';
import Reports from './SubTabs/Reports';
import ENCPreview from './SubTabs/ENCPreview';

const SecondaryTabRoutes = ({ hostName, hostInfo, status }) => (
  <Switch ouiaId="foreman-puppet-switch">
    <Route path={route('reports')}>
      <Reports hostName={hostName} hostInfo={hostInfo} status={status} />
    </Route>
    {/* <Route path={route('assigned')}>
      <EmptyPage
        header={__('Assigned classes')}
        description={__('This tab is still a work in progress')}
      />
    </Route>
    <Route path={route('smart-classes')}>
      <EmptyPage
        header={__('Smart class parameters')}
        description={__('This tab is still a work in progress')}
      />
    </Route> */}
    <Route path={route('yaml')}>
      <ENCPreview hostName={hostName} />
    </Route>
    <Redirect to={route('reports')} />
  </Switch>
);

SecondaryTabRoutes.propTypes = {
  hostName: PropTypes.string,
  hostInfo: PropTypes.object,
  status: PropTypes.string,
};

SecondaryTabRoutes.defaultProps = {
  hostName: '',
  hostInfo: {},
  status: undefined,
};

export default SecondaryTabRoutes;
