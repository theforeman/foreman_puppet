import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { FormattedMessage } from 'react-intl';
import { useDispatch, useSelector } from 'react-redux';
import {
  Alert,
  Modal,
  Button,
  TextContent,
  Text,
  Select,
  SelectOption,
  SelectList,
  MenuToggle,
} from '@patternfly/react-core';
import { addToast } from 'foremanReact/components/ToastsList/slice';
import { sprintf, translate as __ } from 'foremanReact/common/I18n';
import { foremanUrl } from 'foremanReact/common/helpers';
import { APIActions } from 'foremanReact/redux/API';
import { STATUS } from 'foremanReact/constants';
import {
  selectAPIStatus,
  selectAPIResponse,
} from 'foremanReact/redux/API/APISelectors';
import {
  HOSTS_API_PATH,
  API_REQUEST_KEY,
} from 'foremanReact/routes/Hosts/constants';
import {
  fetchSmartProxies,
  SMART_PROXY_KEY,
  bulkChangePuppetProxy,
  BULK_CHANGE_PUPPET_PROXY_KEY,
  BULK_CHANGE_PUPPET_CA_PROXY_KEY,
} from './actions';
import { bulkActionErrorToastParams } from '../toastHelpers';

const BulkChangeProxyCommon = ({
  isOpen,
  closeModal,
  selectAllHostsMode,
  selectedCount,
  fetchBulkParams,
  selectMessage,
  handleErrorMessage,
  changeMessage,
  allHostsMessage,
  someHostsMessage,
  isCAProxy,
}) => {
  const dispatch = useDispatch();
  const [smartProxyId, setSmartProxyId] = useState('');
  const [smartProxySelectOpen, setSmartProxySelectOpen] = useState(false);

  const actionKey = isCAProxy
    ? BULK_CHANGE_PUPPET_CA_PROXY_KEY
    : BULK_CHANGE_PUPPET_PROXY_KEY;
  const smartProxyFeature = isCAProxy ? 'Puppet CA' : 'Puppet';

  useEffect(() => {
    dispatch(fetchSmartProxies(smartProxyFeature));
  }, [dispatch, smartProxyFeature]);

  const smartProxies = useSelector(state =>
    selectAPIResponse(state, SMART_PROXY_KEY)
  );
  const smartProxyStatus = useSelector(state =>
    selectAPIStatus(state, SMART_PROXY_KEY)
  );
  const hasSmartProxies = smartProxies?.results?.length > 0;

  const onToggleClick = () => {
    setSmartProxySelectOpen(!smartProxySelectOpen);
  };

  const handleSmartProxySelect = (event, selection) => {
    setSmartProxyId(selection);
    setSmartProxySelectOpen(false);
  };

  const getSmartProxyLabel = id => id.substring(id.indexOf('-') + 1);

  const toggle = toggleRef => (
    <MenuToggle
      ref={toggleRef}
      onClick={onToggleClick}
      isExpanded={smartProxySelectOpen}
      style={{ width: '500px' }}
    >
      {smartProxyId ? getSmartProxyLabel(smartProxyId) : selectMessage}
    </MenuToggle>
  );

  const handleModalClose = () => {
    setSmartProxyId('');
    closeModal();
  };

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
      proxy_id: smartProxyId.split('-')[0],
      ca_proxy: isCAProxy,
    };

    dispatch(
      bulkChangePuppetProxy(requestBody, handleSuccess, handleError, actionKey)
    );
  };

  const modalActions = [
    <Button
      key="add"
      ouiaId="bulk-change-proxy-common-modal-add-button"
      variant="primary"
      onClick={handleConfirm}
      isDisabled={smartProxyId === ''}
      isLoading={smartProxyStatus === STATUS.PENDING}
    >
      {changeMessage}
    </Button>,
    <Button
      key="cancel"
      ouiaId="bulk-change-proxy-common-modal-cancel-button"
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
      title={changeMessage}
      width="50%"
      position="top"
      actions={modalActions}
      id="bulk-change-proxy-common"
      key="bulk-change-proxy-common"
      ouiaId="bulk-change-proxy-common"
    >
      {(smartProxyStatus !== STATUS.RESOLVED || hasSmartProxies) && (
        <TextContent>
          <Text ouiaId="bulk-change-proxy-common-options">
            {selectAllHostsMode ? (
              <FormattedMessage
                id="bulk-change-proxy-common-warning-message-all"
                defaultMessage={allHostsMessage}
                values={{
                  boldCount: <strong>{__('All')}</strong>,
                }}
              />
            ) : (
              <FormattedMessage
                id="bulk-change-proxy-common-warning-message"
                defaultMessage={someHostsMessage}
                values={{
                  count: selectedCount,
                  boldCount: <strong>{selectedCount}</strong>,
                }}
              />
            )}
          </Text>
        </TextContent>
      )}
      {smartProxyStatus === STATUS.RESOLVED && hasSmartProxies && (
        <Select
          id="single-grouped-select"
          isOpen={smartProxySelectOpen}
          selected={smartProxyId}
          onSelect={handleSmartProxySelect}
          onOpenChange={isSelectOpen => setSmartProxySelectOpen(isSelectOpen)}
          toggle={toggle}
          shouldFocusToggleOnSelect
          ouiaId="bulk-change-proxy-common-select"
        >
          {smartProxies && (
            <SelectList>
              {smartProxies.results?.map(sp => (
                <SelectOption key={`${sp.id}`} value={`${sp.id}-${sp.name}`}>
                  {sp.name}
                </SelectOption>
              ))}
            </SelectList>
          )}
        </Select>
      )}
      {smartProxyStatus === STATUS.RESOLVED && !hasSmartProxies && (
        <Alert
          ouiaId="foreman-puppet-no-proxy-alert"
          isInline
          variant="warning"
          title={sprintf(
            __("There is no Smart Proxy with the feature '%s' available."),
            smartProxyFeature
          )}
        />
      )}
    </Modal>
  );
};

BulkChangeProxyCommon.propTypes = {
  isOpen: PropTypes.bool,
  closeModal: PropTypes.func,
  fetchBulkParams: PropTypes.func.isRequired,
  selectedCount: PropTypes.number.isRequired,
  selectAllHostsMode: PropTypes.bool.isRequired,
  selectMessage: PropTypes.string.isRequired,
  handleErrorMessage: PropTypes.string.isRequired,
  changeMessage: PropTypes.string.isRequired,
  allHostsMessage: PropTypes.string.isRequired,
  someHostsMessage: PropTypes.string.isRequired,
  isCAProxy: PropTypes.bool.isRequired,
};

BulkChangeProxyCommon.defaultProps = {
  isOpen: false,
  closeModal: () => {},
};

export default BulkChangeProxyCommon;
