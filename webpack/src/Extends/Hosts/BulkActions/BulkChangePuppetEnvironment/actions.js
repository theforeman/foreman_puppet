import { APIActions } from 'foremanReact/redux/API';
import { foremanUrl } from 'foremanReact/common/helpers';

export const PUPPET_ENVIRONMENTS_KEY = 'PUPPET_ENVIRONMENTS_KEY';
export const BULK_CHANGE_PUPPET_ENVIRONMENT_KEY =
  'BULK_CHANGE_PUPPET_ENVIRONMENT';

export const INHERIT_ENVIRONMENT = 'inherit';

export const fetchEnvironments = () => {
  const url = foremanUrl('/foreman_puppet/api/v2/environments');
  return APIActions.get({
    key: PUPPET_ENVIRONMENTS_KEY,
    url,
    params: { per_page: 'all' },
  });
};

export const bulkChangePuppetEnvironment = (
  params,
  handleSuccess,
  handleError
) => {
  const url = foremanUrl(
    '/foreman_puppet/api/v2/hosts/bulk/change_environment'
  );
  return APIActions.put({
    key: BULK_CHANGE_PUPPET_ENVIRONMENT_KEY,
    url,
    handleSuccess,
    handleError,
    params,
  });
};

export default fetchEnvironments;
