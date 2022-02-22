import PropTypes from 'prop-types';
import React from 'react';
import { Route, Switch, Redirect } from 'react-router-dom';
import { route } from './helpers';
import EmptyPage from './SubTabs/EmptyPage';
import Reports from './SubTabs/Reports';

const SecondaryTabRoutes = ({ hostName }) => (
  <Switch>
    <Route path={route('reports')}>
      {hostName ? (
        <Reports hostName={hostName} />
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
};

SecondaryTabRoutes.defaultProps = {
  hostName: '',
};

export default SecondaryTabRoutes;
