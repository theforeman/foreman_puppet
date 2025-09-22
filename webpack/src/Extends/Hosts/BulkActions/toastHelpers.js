import { failedHostsToastParams } from 'foremanReact/components/HostsIndex/BulkActions/helpers';

export const bulkActionErrorToastParams = (
  response,
  fallbackMessage,
  actionKey
) => {
  const error = response?.data?.error || response?.response?.data?.error || {};

  return failedHostsToastParams({
    ...error,
    message: error.message || fallbackMessage,
    key: actionKey,
  });
};

export default bulkActionErrorToastParams;
