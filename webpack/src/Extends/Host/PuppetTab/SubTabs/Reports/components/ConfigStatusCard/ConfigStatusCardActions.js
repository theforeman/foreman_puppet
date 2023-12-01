import { API_OPERATIONS, get } from 'foremanReact/redux/API';
import { FOREMAN_PUPPET_LAST_REPORT_KEY } from './ConfigStatusCardConstants';

export const getReportByIdAction = reportId =>
  get({
    type: API_OPERATIONS.GET,
    key: FOREMAN_PUPPET_LAST_REPORT_KEY,
    url: `/api/config_reports/${reportId}`,
  });
export default getReportByIdAction;
