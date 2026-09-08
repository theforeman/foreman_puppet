import 'foremanJSTestSetup';

jest.mock('foremanReact/redux/API/APISelectors', () =>
  jest.requireActual('foremanReact/redux/API/APISelectors')
);

jest.mock('foremanReact/redux/API/API', () => {
  const { API } = jest.requireActual(
    './__mocks__/foremanReact/redux/API/index'
  );

  return {
    __esModule: true,
    default: API,
  };
});

jest.mock('foremanReact/redux/API', () =>
  jest.requireActual('./__mocks__/foremanReact/redux/API/index')
);
