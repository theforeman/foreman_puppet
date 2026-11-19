import React from 'react';
import PropTypes from 'prop-types';
import { FormattedMessage } from 'react-intl';
import { useDispatch } from 'react-redux';
import {
  Button,
  Content,
  Modal,
  ModalBody,
  ModalFooter,
  ModalHeader,
} from '@patternfly/react-core';
import { translate as __ } from 'foremanReact/common/I18n';
import { addToast } from 'foremanReact/components/ToastsList/slice';
import { useForemanOrganization } from 'foremanReact/Root/Context/ForemanContext';
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
  onSuccess: onSuccessCallback,
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
    try {
      if (onSuccessCallback) onSuccessCallback();
    } finally {
      handleModalClose();
    }
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

  const modalTitle = __('Remove Puppet Environment');
  const modalTitleId = 'bulk-remove-puppet-environment-title';

  return (
    <Modal
      isOpen={isOpen}
      onClose={handleModalClose}
      onEscapePress={handleModalClose}
      width="50%"
      position="top"
      id="bulk-remove-puppet-environment"
      ouiaId="bulk-remove-puppet-environment"
      aria-labelledby={modalTitleId}
    >
      <ModalHeader title={modalTitle} labelId={modalTitleId} />
      <ModalBody>
        <Content>
          <Content component="p" ouiaId="bulk-remove-puppet-environment-options">
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
          </Content>
        </Content>
      </ModalBody>
      <ModalFooter>{modalActions}</ModalFooter>
    </Modal>
  );
};

BulkRemovePuppetEnvironmentModal.propTypes = {
  isOpen: PropTypes.bool,
  closeModal: PropTypes.func,
  fetchBulkParams: PropTypes.func.isRequired,
  onSuccess: PropTypes.func,
  selectedCount: PropTypes.number.isRequired,
  selectAllHostsMode: PropTypes.bool.isRequired,
};

BulkRemovePuppetEnvironmentModal.defaultProps = {
  isOpen: false,
  closeModal: () => {},
  onSuccess: undefined,
};

export default BulkRemovePuppetEnvironmentModal;
