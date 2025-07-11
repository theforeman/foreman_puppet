import PropTypes from 'prop-types';
import React, { useCallback, useEffect } from 'react';
import {
  Divider,
  Flex,
  FlexItem,
  Button,
  DescriptionList,
  DescriptionListTerm,
  DescriptionListGroup,
  DescriptionListDescription,
} from '@patternfly/react-core';
import { Table, TableText, Tr, Tbody, Td } from '@patternfly/react-table';
import { useSelector, useDispatch } from 'react-redux';
import { selectAPIResponse } from 'foremanReact/redux/API/APISelectors';
import CardTemplate from 'foremanReact/components/HostDetails/Templates/CardItem/CardTemplate';
import RelativeDateTime from 'foremanReact/components/common/dates/RelativeDateTime';
import SkeletonLoader from 'foremanReact/components/common/SkeletonLoader';
import DefaultLoaderEmptyState from 'foremanReact/components/HostDetails/DetailsCard/DefaultLoaderEmptyState';
import { statusFormatter } from 'foremanReact/components/HostDetails/Tabs/ReportsTab/helpers';
import { translate as __ } from 'foremanReact/common/I18n';

import { getReportByIdAction } from './ConfigStatusCardActions';
import { FOREMAN_PUPPET_LAST_REPORT_KEY } from './ConfigStatusCardConstants';
import './styles.scss';

const cardHeaderDivider = () => (
  <Divider
    orientation={{
      default: 'vertical',
    }}
    inset={{ default: 'insetMd' }}
  />
);

const generateCardHeader = (allReports = [], reportsCount) =>
  reportsCount > 0 ? (
    <>
      {__('Last configuration status')}
      <Flex>
        <FlexItem>
          <Button
            ouiaId="foreman-puppet-last-report-button"
            variant="link"
            component="a"
            isInline
            isDisabled={!allReports.length}
            href={`/config_reports/${allReports[0].id}`}
          >
            <RelativeDateTime
              date={allReports[0].reported_at}
              defaultValue={__('Never')}
            />
          </Button>
        </FlexItem>
        <FlexItem>{statusFormatter('failed', allReports[0])}</FlexItem>
        {cardHeaderDivider()}
        <FlexItem>{statusFormatter('failed_restarts', allReports[0])}</FlexItem>
        {cardHeaderDivider()}
        <FlexItem>{statusFormatter('restarted', allReports[0])}</FlexItem>
        {cardHeaderDivider()}
        <FlexItem>{statusFormatter('applied', allReports[0])}</FlexItem>
        {cardHeaderDivider()}
        <FlexItem>{statusFormatter('skipped', allReports[0])}</FlexItem>
        {cardHeaderDivider()}
        <FlexItem>{statusFormatter('pending', allReports[0])}</FlexItem>
      </Flex>
    </>
  ) : (
    <> {__('No configuration status available')} </>
  );

const createPuppetMetricsTableElement = (name, value = '--') => (
  <>
    <Td modifier="truncate" key={`metrics-name-${name}`}>
      <TableText
        className={name === 'Total' ? 'last-config-puppet-metrics-total' : ''}
      >
        {name}
      </TableText>
    </Td>
    <Td modifier="truncate" key={`metrics-name-${value}`}>
      <TableText
        className={name === 'Total' ? 'last-config-puppet-metrics-total' : ''}
      >
        {value}
      </TableText>
    </Td>
  </>
);

const createPuppetMetricsTable = (metrics = undefined) => (
  <Table
    aria-label="foreman puppet metrics table"
    variant="compact"
    borders="compactBorderless"
    ouiaId="foreman-puppet-metrics-table"
    key="foreman-puppet-metrics-table"
  >
    <Tbody>
      <Tr ouiaId="foreman-puppet-metrics-row-1">
        {createPuppetMetricsTableElement(__('Failed'), metrics.failed)}
        {createPuppetMetricsTableElement(__('Changed'), metrics.changed)}
        {createPuppetMetricsTableElement(__('Scheduled'), metrics.scheduled)}
      </Tr>
      <Tr ouiaId="foreman-puppet-metrics-row-2">
        {createPuppetMetricsTableElement(
          __('Failed to start'),
          metrics.failed_to_start
        )}
        {createPuppetMetricsTableElement(__('Restarted'), metrics.restarted)}
        {createPuppetMetricsTableElement(
          __('Corrective Change'),
          metrics.corrective_change
        )}
      </Tr>
      <Tr ouiaId="foreman-puppet-metrics-row-3">
        {createPuppetMetricsTableElement(__('Skipped'), metrics.skipped)}
        {createPuppetMetricsTableElement(
          __('Out of sync'),
          metrics.out_of_sync
        )}
        {createPuppetMetricsTableElement(__('Total'), metrics.total)}
      </Tr>
    </Tbody>
  </Table>
);

const ConfigStatusCard = ({ hostName, parentStatus }) => {
  const dispatch = useDispatch();
  // get already fetched results from reports tab
  const API_KEY = `get-reports-${hostName}`;
  const { reports, itemCount } = useSelector(state =>
    selectAPIResponse(state, API_KEY)
  );

  // we need to fetch the last Puppet report to get all Puppet metrics
  const getLastReport = useCallback(() => {
    if (hostName && reports?.length)
      dispatch(getReportByIdAction(reports[0].id));
  }, [hostName, reports, dispatch]);

  useEffect(() => {
    getLastReport();
  }, [hostName, reports]);

  const { metrics } = useSelector(state =>
    selectAPIResponse(state, FOREMAN_PUPPET_LAST_REPORT_KEY)
  );

  return (
    <CardTemplate header={generateCardHeader(reports, itemCount)} expandable>
      <DescriptionList isCompact>
        <DescriptionListGroup>
          <DescriptionListTerm>{__('Puppet metrics')}</DescriptionListTerm>
          <DescriptionListDescription>
            <SkeletonLoader
              status={parentStatus}
              emptyState={<DefaultLoaderEmptyState />}
            >
              {metrics && createPuppetMetricsTable(metrics.resources)}
            </SkeletonLoader>
          </DescriptionListDescription>
        </DescriptionListGroup>
      </DescriptionList>
    </CardTemplate>
  );
};

ConfigStatusCard.propTypes = {
  hostName: PropTypes.string,
  parentStatus: PropTypes.string,
};

ConfigStatusCard.defaultProps = {
  hostName: undefined,
  parentStatus: undefined,
};

export default ConfigStatusCard;
