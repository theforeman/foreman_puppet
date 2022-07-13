import PropTypes from 'prop-types';
import React from 'react';
import { Grid, GridItem } from '@patternfly/react-core';
import ReportsTab from 'foremanReact/components/HostDetails/Tabs/ReportsTab';
import DescriptionCard from './components/DescriptionCard';
import './styles.scss';

const Reports = ({
  hostName,
  status,
  hostInfo: {
    puppet_proxy_name: proxyName,
    puppet_ca_proxy_name: caProxy,
    environment_name: env,
    puppet_proxy_id: proxyId,
    puppet_ca_proxy_id: caProxyId,
  },
}) => (
  <div className="report-tab">
    <Grid hasGutter>
      <GridItem span={4}>
        <DescriptionCard
          proxyName={proxyName}
          caProxy={caProxy}
          proxyId={proxyId}
          caProxyId={caProxyId}
          env={env}
          status={status}
        />
      </GridItem>
      <GridItem span={12}>
        <ReportsTab hostName={hostName} origin="Puppet" />
      </GridItem>
    </Grid>
  </div>
);

Reports.propTypes = {
  hostName: PropTypes.string,
  hostInfo: PropTypes.object,
  status: PropTypes.string,
};

Reports.defaultProps = {
  hostName: undefined,
  hostInfo: {},
  status: undefined,
};

export default Reports;
