import React from 'react';
import PropTypes from 'prop-types';
import PFEmptyPage from 'foremanReact/components/common/EmptyState/EmptyStatePattern';

const EmptyPage = ({ header, description }) => (
  <div className="host-details-tab-item">
    <PFEmptyPage icon="enterprise" header={header} description={description} />
  </div>
);

EmptyPage.propTypes = {
  header: PropTypes.string.isRequired,
  description: PropTypes.string,
};

EmptyPage.defaultProps = {
  description: null,
};

export default EmptyPage;
