import React from 'react';
import PropTypes from 'prop-types';
import { FormattedMessage } from 'react-intl';
import { useDispatch } from 'react-redux';
import { Modal, Button, TextContent, Text } from '@patternfly/react-core';
import { addToast } from 'foremanReact/components/ToastsList/slice';
import { translate as __ } from 'foremanReact/common/I18n';

import {
  BULK_REMOVE_PUPPET_PROXY_KEY,
  BULK_REMOVE_PUPPET_CA_PROXY_KEY,
  bulkRemovePuppetProxyAction,
} from './actions';
import { bulkActionErrorToastParams } from '../toastHelpers';

const BulkRemoveProxyCommon = ({
  isCAProxy,
  isOpen,
  closeModal,
  selectAllHostsMode,
  selectedCount,
  fetchBulkParams,
  handleErrorMessage,
  removeMessage,
  allHostsMessage,
  someHostsMessage,
  onSuccess: onSuccessCallback,
}) => {
  const actionKey = isCAProxy
    ? BULK_REMOVE_PUPPET_CA_PROXY_KEY
    : BULK_REMOVE_PUPPET_PROXY_KEY;

  const handleModalClose = () => {
    closeModal();
  };

  const dispatch = useDispatch();

  const handleError = response => {
    handleModalClose();
    dispatch(
      addToast(
        bulkActionErrorToastParams(response, handleErrorMessage, actionKey)
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
      ca_proxy: isCAProxy,
    };

    dispatch(
      bulkRemovePuppetProxyAction(
        actionKey,
        requestBody,
        handleSuccess,
        handleError
      )
    );
  };

  const modalActions = [
    <Button
      key="add"
      ouiaId="bulk-remove-proxy-common-modal-add-button"
      variant="primary"
      onClick={handleConfirm}
    >
      {removeMessage}
    </Button>,
    <Button
      key="cancel"
      ouiaId="bulk-remove-proxy-common-modal-cancel-button"
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
      title={removeMessage}
      width="50%"
      position="top"
      actions={modalActions}
      id="bulk-remove-proxy-common"
      key="bulk-remove-proxy-common"
      ouiaId="bulk-remove-proxy-common"
    >
      <TextContent>
        <Text ouiaId="bulk-remove-proxy-common-options">
          {selectAllHostsMode ? (
            <FormattedMessage
              id="bulk-remove-proxy-common-warning-message-all"
              defaultMessage={allHostsMessage}
              values={{
                boldCount: <strong>{__('All')}</strong>,
              }}
            />
          ) : (
            <FormattedMessage
              id="bulk-remove-proxy-common-warning-message"
              defaultMessage={someHostsMessage}
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

BulkRemoveProxyCommon.propTypes = {
  isCAProxy: PropTypes.bool.isRequired,
  isOpen: PropTypes.bool,
  closeModal: PropTypes.func,
  fetchBulkParams: PropTypes.func.isRequired,
  selectedCount: PropTypes.number.isRequired,
  selectAllHostsMode: PropTypes.bool.isRequired,
  handleErrorMessage: PropTypes.string.isRequired,
  removeMessage: PropTypes.string,
  allHostsMessage: PropTypes.string.isRequired,
  someHostsMessage: PropTypes.string.isRequired,
  onSuccess: PropTypes.func,
};

BulkRemoveProxyCommon.defaultProps = {
  isOpen: false,
  closeModal: () => {},
  removeMessage: 'Remove Puppet (CA) Proxy',
  onSuccess: undefined,
};

export default BulkRemoveProxyCommon;
