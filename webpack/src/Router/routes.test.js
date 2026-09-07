import React from 'react';
import { createMemoryHistory } from 'history';
import { Router, Route, Switch } from 'react-router-dom';
import { screen } from '@testing-library/react';
import '@testing-library/jest-dom';

import routes from './routes';
import ForemanPuppetRouter from './index';
import { exampleRoutes } from './routes.fixtures';
import { rtlHelpers } from 'foremanReact/common/rtlTestHelpers';

const { renderWithStore } = rtlHelpers;

const renderForemanPuppetRouterAtPath = path => {
  const history = createMemoryHistory({ initialEntries: [path] });

  return renderWithStore(
    <Router history={history}>
      <ForemanPuppetRouter />
    </Router>
  );
};

const renderRoutesAtPath = (routeMap, path) => {
  const history = createMemoryHistory({ initialEntries: [path] });

  return renderWithStore(
    <Router history={history}>
      <Switch>
        {Object.entries(routeMap).map(([key, props]) => (
          <Route key={key} {...props} />
        ))}
      </Switch>
    </Router>
  );
};

describe('ForemanPuppetRoutes', () => {
  it('exports an empty routes configuration object', () => {
    expect(routes).toEqual({});
    expect(routes).not.toBeNull();
    expect(Array.isArray(routes)).toBe(false);
  });

  describe('fixture routes', () => {
    it('defines valid route entries', () => {
      Object.entries(exampleRoutes).forEach(([routeKey, route]) => {
        expect(routeKey).toBeTruthy();
        expect(route).toEqual(
          expect.objectContaining({
            path: expect.any(String),
            component: expect.any(Function),
          })
        );
      });
    });

    it('renders a fixture route at its path', () => {
      const { path } = exampleRoutes.example;

      renderRoutesAtPath(exampleRoutes, path);

      expect(
        screen.getByRole('heading', { name: 'Foreman Puppet example route' })
      ).toBeInTheDocument();
    });
  });

  describe('ForemanPuppetRouter', () => {
    it('renders without content when no routes are configured', () => {
      const { container } = renderForemanPuppetRouterAtPath('/');

      expect(container).toBeEmptyDOMElement();
    });
  });
});
