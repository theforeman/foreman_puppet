import { APIActions } from 'foremanReact/redux/API';
import { foremanUrl } from 'foremanReact/common/helpers';

import {
  fetchSmartProxies,
  SMART_PROXY_KEY,
  bulkChangePuppetProxy,
  BULK_CHANGE_PUPPET_CA_PROXY_KEY,
  BULK_CHANGE_PUPPET_PROXY_KEY,
} from '../actions';

jest.mock('foremanReact/redux/API', () => ({
  APIActions: {
    get: jest.fn(),
    put: jest.fn(),
  },
}));

describe('BulkChangeProxyCommon actions', () => {
  const smartProxiesUrl = foremanUrl('/api/smart_proxies');
  const bulkChangeUrl = foremanUrl('/api/v2/hosts/bulk/change_puppet_proxy');

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('fetches smart proxies list filtered by feature search', () => {
    fetchSmartProxies('Puppet');

    expect(APIActions.get).toHaveBeenCalledWith({
      key: SMART_PROXY_KEY,
      url: smartProxiesUrl,
      params: { per_page: 'all', search: 'feature = "Puppet"' },
    });
  });

  it('calls bulk change puppet proxy endpoint for Puppet Proxy changes', () => {
    const params = { included: { ids: [1] }, proxy_id: '1', ca_proxy: false };
    const handleSuccess = jest.fn();
    const handleError = jest.fn();

    bulkChangePuppetProxy(
      params,
      handleSuccess,
      handleError,
      BULK_CHANGE_PUPPET_PROXY_KEY
    );

    expect(APIActions.put).toHaveBeenCalledWith({
      key: BULK_CHANGE_PUPPET_PROXY_KEY,
      url: bulkChangeUrl,
      handleSuccess,
      handleError,
      params,
    });
  });

  it('calls bulk change puppet proxy endpoint for Puppet CA Proxy changes', () => {
    const params = { included: { ids: [1] }, proxy_id: '1', ca_proxy: true };
    const handleSuccess = jest.fn();
    const handleError = jest.fn();

    bulkChangePuppetProxy(
      params,
      handleSuccess,
      handleError,
      BULK_CHANGE_PUPPET_CA_PROXY_KEY
    );

    expect(APIActions.put).toHaveBeenCalledWith({
      key: BULK_CHANGE_PUPPET_CA_PROXY_KEY,
      url: bulkChangeUrl,
      handleSuccess,
      handleError,
      params,
    });
  });
});
