const path = require('path');

const foremanFull = path.resolve(__dirname, '..', 'foreman');
const foremanReactFull = path.join(
  foremanFull,
  'webpack/assets/javascripts/react_app'
);
const foremanJestConfig = require(path.join(foremanFull, 'webpack/jest.config.js'));

foremanJestConfig.moduleNameMapper['^foremanReact(.*)$'] = `${foremanReactFull}/$1`;

foremanJestConfig.resolver = null;
foremanJestConfig.moduleDirectories = [
  `${foremanFull}/node_modules`,
  `${foremanFull}/node_modules/@theforeman/vendor-core/node_modules`,
  'node_modules',
];

foremanJestConfig.setupFilesAfterEnv = [
  path.join(__dirname, 'webpack/test_setup.js'),
  path.join(foremanFull, 'webpack/global_test_setup.js'),
  path.join(foremanFull, 'webpack/core_test_setup.js'),
];

module.exports = foremanJestConfig;