import PropTypes from 'prop-types';
import React from 'react';
import { Grid, GridItem } from '@patternfly/react-core';
import Slot from 'foremanReact/components/common/Slot';
import CardTemplate from 'foremanReact/components/HostDetails/Templates/CardItem/CardTemplate';
import { translate as __ } from 'foremanReact/common/I18n';
import './styles.scss';

const Reports = ({ hostName }) => (
  <div className="report-tab">
    <Grid hasGutter>
      <GridItem span={8}>
        <CardTemplate header={__('Last config status')} expandable>
          TBD
        </CardTemplate>
      </GridItem>
      <GridItem span={4}>
        <CardTemplate header={__('Puppet details')} expandable>
          TBD
        </CardTemplate>
      </GridItem>
      <GridItem span={12}>
        <Slot hostName={hostName} id="[puppet]-reports" />
      </GridItem>
    </Grid>
  </div>
);

Reports.propTypes = {
  hostName: PropTypes.string.isRequired,
};

export default Reports;
