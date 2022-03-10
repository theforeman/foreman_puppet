import PropTypes from 'prop-types';
import React from 'react';
import { Grid, GridItem } from '@patternfly/react-core';
import Slot from 'foremanReact/components/common/Slot';
import CardTemplate from 'foremanReact/components/HostDetails/Templates/CardItem/CardTemplate';
import { translate as __ } from 'foremanReact/common/I18n';
import './styles.scss';
import DescriptionCard from './components/DescriptionCard';

const Reports = ({
  hostName,
  status,
  hostInfo: {
    puppet_proxy_name: proxyName,
    puppet_ca_proxy_name: caProxy,
    environment_name: env,
  },
}) => (
  <div className="report-tab">
    <Grid hasGutter>
      <GridItem span={8}>
        <CardTemplate header={__('Last config status')} expandable>
          TBD
        </CardTemplate>
      </GridItem>
      <GridItem span={4}>
        <DescriptionCard
          proxyName={proxyName}
          caProxy={caProxy}
          env={env}
          status={status}
        />
      </GridItem>
      <GridItem span={12}>
        <Slot hostName={hostName} id="[puppet]-reports" />
      </GridItem>
    </Grid>
  </div>
);

Reports.propTypes = {
  hostName: PropTypes.string.isRequired,
  hostInfo: PropTypes.object,
  status: PropTypes.string,
};

Reports.defaultProps = {
  hostInfo: {},
  status: undefined,
};

export default Reports;
