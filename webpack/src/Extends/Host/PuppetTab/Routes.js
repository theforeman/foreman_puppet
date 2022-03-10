import PropTypes from 'prop-types';
import React from 'react';
import { Route, Switch, Redirect } from 'react-router-dom';
import { route } from './helpers';
import EmptyPage from './SubTabs/EmptyPage';
import Reports from './SubTabs/Reports';

const SecondaryTabRoutes = ({ hostName, hostInfo, status }) => (
  <Switch>
    <Route path={route('reports')}>
      {hostName ? (
        <Reports hostName={hostName} hostInfo={hostInfo} status={status} />
      ) : (
        <EmptyPage header="Reports" />
      )}
    </Route>
    <Route path={route('assigned')}>
      <EmptyPage header="Assigned classes" />
    </Route>
    <Route path={route('smart-classes')}>
      <EmptyPage header="Smart class parameters" />
    </Route>
    <Route path={route('yaml')}>
      <EmptyPage header="YAML" />
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
