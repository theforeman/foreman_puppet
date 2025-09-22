import { APIActions } from 'foremanReact/redux/API';
import { foremanUrl } from 'foremanReact/common/helpers';

export const SMART_PROXY_KEY = 'SMART_PROXY_KEY';
export const BULK_CHANGE_PUPPET_CA_PROXY_KEY = 'BULK_CHANGE_PUPPET_CA_PROXY';
export const BULK_CHANGE_PUPPET_PROXY_KEY = 'BULK_CHANGE_PUPPET_PROXY';

export const fetchSmartProxies = feature => {
  const url = foremanUrl('/api/smart_proxies');
  return APIActions.get({
    key: SMART_PROXY_KEY,
    url,
    params: {
      per_page: 'all',
      ...(feature ? { search: `feature = "${feature}"` } : {}),
    },
  });
};

export const bulkChangePuppetProxy = (
  params,
  handleSuccess,
  handleError,
  key
) => {
  const url = foremanUrl(`/api/v2/hosts/bulk/change_puppet_proxy`);
  return APIActions.put({
    key,
    url,
    handleSuccess,
    handleError,
    params,
  });
};

export default fetchSmartProxies;
