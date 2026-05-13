import { APIActions } from 'foremanReact/redux/API';
import { foremanUrl } from 'foremanReact/common/helpers';

export const BULK_REMOVE_PUPPET_PROXY_KEY = 'BULK_REMOVE_PUPPET_PROXY_KEY';
export const BULK_REMOVE_PUPPET_CA_PROXY_KEY =
  'BULK_REMOVE_PUPPET_CA_PROXY_KEY';

export const bulkRemovePuppetProxyAction = (
  key,
  params,
  handleSuccess,
  handleError
) => {
  const url = foremanUrl(`/api/v2/hosts/bulk/remove_puppet_proxy`);
  return APIActions.put({
    key,
    url,
    handleSuccess,
    handleError,
    params,
  });
};

export default bulkRemovePuppetProxyAction;
