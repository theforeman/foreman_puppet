import { bulkActionErrorToastParams } from '../toastHelpers';

jest.mock('foremanReact/components/HostsIndex/BulkActions/helpers', () => ({
  failedHostsToastParams: jest.fn(params => params),
}));

describe('bulkActionErrorToastParams', () => {
  const actionKey = 'BULK_ACTION_KEY';
  const fallbackMessage = 'Fallback error';

  it('uses the API error payload message when present', () => {
    const response = {
      data: {
        error: {
          message: 'API error',
          failed_host_ids: [1, 2],
        },
      },
    };

    expect(
      bulkActionErrorToastParams(response, fallbackMessage, actionKey)
    ).toEqual({
      message: 'API error',
      failed_host_ids: [1, 2],
      key: actionKey,
    });
  });

  it('supports axios-style wrapped error responses', () => {
    const response = {
      response: {
        data: {
          error: {
            message: 'Wrapped API error',
          },
        },
      },
    };

    expect(
      bulkActionErrorToastParams(response, fallbackMessage, actionKey)
    ).toEqual({
      message: 'Wrapped API error',
      key: actionKey,
    });
  });

  it('falls back to the generic message when the API message is missing', () => {
    expect(bulkActionErrorToastParams({}, fallbackMessage, actionKey)).toEqual({
      message: fallbackMessage,
      key: actionKey,
    });
  });
});
