import { APIActions } from 'foremanReact/redux/API';
import { foremanUrl } from 'foremanReact/common/helpers';

import {
  bulkRemovePuppetProxyAction,
  BULK_REMOVE_PUPPET_PROXY_KEY,
  BULK_REMOVE_PUPPET_CA_PROXY_KEY,
} from '../actions';

jest.mock('foremanReact/redux/API', () => ({
  APIActions: {
    put: jest.fn(),
  },
}));

describe('BulkRemoveProxyCommon actions', () => {
  const url = foremanUrl('/api/v2/hosts/bulk/remove_puppet_proxy');

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('calls bulk remove puppet proxy endpoint for Puppet Proxy removal', () => {
    const params = { included: { ids: [1] }, ca_proxy: false };
    const handleSuccess = jest.fn();
    const handleError = jest.fn();

    bulkRemovePuppetProxyAction(
      BULK_REMOVE_PUPPET_PROXY_KEY,
      params,
      handleSuccess,
      handleError
    );

    expect(APIActions.put).toHaveBeenCalledWith({
      key: BULK_REMOVE_PUPPET_PROXY_KEY,
      url,
      handleSuccess,
      handleError,
      params,
    });
  });

  it('calls bulk remove puppet proxy endpoint for Puppet CA Proxy removal', () => {
    const params = { included: { ids: [1] }, ca_proxy: true };
    const handleSuccess = jest.fn();
    const handleError = jest.fn();

    bulkRemovePuppetProxyAction(
      BULK_REMOVE_PUPPET_CA_PROXY_KEY,
      params,
      handleSuccess,
      handleError
    );

    expect(APIActions.put).toHaveBeenCalledWith({
      key: BULK_REMOVE_PUPPET_CA_PROXY_KEY,
      url,
      handleSuccess,
      handleError,
      params,
    });
  });
});
