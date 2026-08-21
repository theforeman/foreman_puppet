import React from 'react';
import PropTypes from 'prop-types';
import { FormattedMessage } from 'react-intl';
import { useDispatch } from 'react-redux';
import { Modal, Button, TextContent, Text } from '@patternfly/react-core';
import { translate as __ } from 'foremanReact/common/I18n';
import { addToast } from 'foremanReact/components/ToastsList/slice';
import { foremanUrl } from 'foremanReact/common/helpers';
import { useForemanOrganization } from 'foremanReact/Root/Context/ForemanContext';
import { APIActions } from 'foremanReact/redux/API';
import {
  HOSTS_API_PATH,
  API_REQUEST_KEY,
} from 'foremanReact/routes/Hosts/constants';
import { bulkActionErrorToastParams } from '../toastHelpers';
import {
  bulkChangePuppetEnvironment,
  BULK_CHANGE_PUPPET_ENVIRONMENT_KEY,
} from '../BulkChangePuppetEnvironment/actions';

const BulkRemovePuppetEnvironmentModal = ({
  isOpen,
  closeModal,
  selectAllHostsMode,
  selectedCount,
  fetchBulkParams,
}) => {
  const dispatch = useDispatch();
  const currentOrganization = useForemanOrganization();

  const handleModalClose = () => {
    closeModal();
  };

  const handleError = response => {
    handleModalClose();
    dispatch(
      addToast(
        bulkActionErrorToastParams(
          response,
          __('Failed to remove Puppet Environment'),
          BULK_CHANGE_PUPPET_ENVIRONMENT_KEY
        )
      )
    );
  };

  const handleSuccess = response => {
    dispatch(
      addToast({
        type: 'success',
        message: response.data.message,
      })
    );
    dispatch(
      APIActions.get({
        key: API_REQUEST_KEY,
        url: foremanUrl(HOSTS_API_PATH),
      })
    );
    handleModalClose();
  };

  const handleConfirm = () => {
    const requestBody = {
      included: {
        search: fetchBulkParams(),
      },
      environment_id: null,
      organization_id: currentOrganization?.id,
    };

    dispatch(
      bulkChangePuppetEnvironment(requestBody, handleSuccess, handleError)
    );
  };

  const modalActions = [
    <Button
      key="remove"
      ouiaId="bulk-remove-puppet-environment-modal-remove-button"
      variant="primary"
      onClick={handleConfirm}
    >
      {__('Remove Puppet Environment')}
    </Button>,
    <Button
      key="cancel"
      ouiaId="bulk-remove-puppet-environment-modal-cancel-button"
      variant="link"
      onClick={handleModalClose}
    >
      {__('Cancel')}
    </Button>,
  ];

  return (
    <Modal
      isOpen={isOpen}
      onClose={handleModalClose}
      onEscapePress={handleModalClose}
      title={__('Remove Puppet Environment')}
      width="50%"
      position="top"
      actions={modalActions}
      id="bulk-remove-puppet-environment"
      key="bulk-remove-puppet-environment"
      ouiaId="bulk-remove-puppet-environment"
    >
      <TextContent>
        <Text ouiaId="bulk-remove-puppet-environment-options">
          {selectAllHostsMode ? (
            <FormattedMessage
              id="bulk-remove-puppet-environment-warning-message-all"
              defaultMessage={__(
                'Removing the Puppet environment will affect {boldCount} selected hosts.'
              )}
              values={{
                boldCount: <strong>{__('All')}</strong>,
              }}
            />
          ) : (
            <FormattedMessage
              id="bulk-remove-puppet-environment-warning-message"
              defaultMessage={__(
                'Removing the Puppet environment will affect {boldCount} selected {count, plural, one {host} other {hosts}}.'
              )}
              values={{
                count: selectedCount,
                boldCount: <strong>{selectedCount}</strong>,
              }}
            />
          )}
        </Text>
      </TextContent>
    </Modal>
  );
};

BulkRemovePuppetEnvironmentModal.propTypes = {
  isOpen: PropTypes.bool,
  closeModal: PropTypes.func,
  fetchBulkParams: PropTypes.func.isRequired,
  selectedCount: PropTypes.number.isRequired,
  selectAllHostsMode: PropTypes.bool.isRequired,
};

BulkRemovePuppetEnvironmentModal.defaultProps = {
  isOpen: false,
  closeModal: () => {},
};

export default BulkRemovePuppetEnvironmentModal;
