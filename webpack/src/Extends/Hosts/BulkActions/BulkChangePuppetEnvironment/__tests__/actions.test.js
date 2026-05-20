import { APIActions } from 'foremanReact/redux/API';
import {
  fetchEnvironments,
  PUPPET_ENVIRONMENTS_KEY,
  bulkChangePuppetEnvironment,
  BULK_CHANGE_PUPPET_ENVIRONMENT_KEY,
} from '../actions';

jest.mock('foremanReact/redux/API', () => ({
  APIActions: {
    get: jest.fn(),
    put: jest.fn(),
  },
}));

describe('BulkChangePuppetEnvironment actions', () => {
  const environmentsUrl = '/foreman_puppet/api/v2/environments';
  const bulkChangeUrl = '/foreman_puppet/api/v2/hosts/bulk/change_environment';

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('fetches environments', () => {
    fetchEnvironments();

    expect(APIActions.get).toHaveBeenCalledWith({
      key: PUPPET_ENVIRONMENTS_KEY,
      url: environmentsUrl,
      params: { per_page: 'all' },
    });
  });

  it('calls bulk change puppet environment endpoint', () => {
    const params = { included: { ids: [1] }, environment_id: '1' };
    const handleSuccess = jest.fn();
    const handleError = jest.fn();

    bulkChangePuppetEnvironment(params, handleSuccess, handleError);

    expect(APIActions.put).toHaveBeenCalledWith({
      key: BULK_CHANGE_PUPPET_ENVIRONMENT_KEY,
      url: bulkChangeUrl,
      handleSuccess,
      handleError,
      params,
    });
  });
});
