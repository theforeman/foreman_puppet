import React from 'react';

export const ExampleRoutePage = () => (
  <h1>Foreman Puppet example route</h1>
);

export const exampleRoutes = {
  example: {
    path: '/foreman_puppet_example',
    exact: true,
    component: ExampleRoutePage,
  },
};
