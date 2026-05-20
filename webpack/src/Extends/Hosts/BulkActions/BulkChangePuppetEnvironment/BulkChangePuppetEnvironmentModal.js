import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { FormattedMessage } from 'react-intl';
import { useDispatch, useSelector } from 'react-redux';
import {
  Modal,
  Button,
  TextContent,
  Text,
  Select,
  SelectOption,
  SelectList,
  MenuToggle,
} from '@patternfly/react-core';
import { translate as __ } from 'foremanReact/common/I18n';
import { addToast } from 'foremanReact/components/ToastsList/slice';
import { foremanUrl } from 'foremanReact/common/helpers';
import { useForemanOrganization } from 'foremanReact/Root/Context/ForemanContext';
import { APIActions } from 'foremanReact/redux/API';
import {
  selectAPIStatus,
  selectAPIResponse,
} from 'foremanReact/redux/API/APISelectors';
import { STATUS } from 'foremanReact/constants';
import {
  HOSTS_API_PATH,
  API_REQUEST_KEY,
} from 'foremanReact/routes/Hosts/constants';
import { bulkActionErrorToastParams } from '../toastHelpers';
import {
  fetchEnvironments,
  bulkChangePuppetEnvironment,
  PUPPET_ENVIRONMENTS_KEY,
  BULK_CHANGE_PUPPET_ENVIRONMENT_KEY,
  INHERIT_ENVIRONMENT,
} from './actions';

const BulkChangePuppetEnvironmentModal = ({
  isOpen,
  closeModal,
  selectAllHostsMode,
  selectedCount,
  fetchBulkParams,
}) => {
  const dispatch = useDispatch();
  const [environmentId, setEnvironmentId] = useState(null);
  const [environmentSelectOpen, setEnvironmentSelectOpen] = useState(false);
  const currentOrganization = useForemanOrganization();

  useEffect(() => {
    dispatch(fetchEnvironments());
  }, [dispatch]);

  const environments = useSelector(state =>
    selectAPIResponse(state, PUPPET_ENVIRONMENTS_KEY)
  );
  const environmentsStatus = useSelector(state =>
    selectAPIStatus(state, PUPPET_ENVIRONMENTS_KEY)
  );

  const onToggleClick = () => {
    setEnvironmentSelectOpen(!environmentSelectOpen);
  };

  const handleEnvironmentSelect = (event, selection) => {
    setEnvironmentId(selection);
    setEnvironmentSelectOpen(false);
  };

  const getEnvironmentLabel = value => {
    if (value === INHERIT_ENVIRONMENT) return __('*Inherit from host group*');

    const selectedEnvironment = environments?.results?.find(
      environment => `${environment.id}` === value
    );
    return selectedEnvironment?.name || __('Select an Environment');
  };

  const toggle = toggleRef => (
    <MenuToggle
      ref={toggleRef}
      onClick={onToggleClick}
      isExpanded={environmentSelectOpen}
      style={{ width: '500px' }}
    >
      {environmentId
        ? getEnvironmentLabel(environmentId)
        : __('Select an Environment')}
    </MenuToggle>
  );

  const handleModalClose = () => {
    setEnvironmentId(null);
    closeModal();
  };

  const handleError = response => {
    handleModalClose();
    dispatch(
      addToast(
        bulkActionErrorToastParams(
          response,
          __('Failed to change Puppet Environment'),
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
      environment_id: environmentId,
      organization_id: currentOrganization?.id,
    };

    dispatch(
      bulkChangePuppetEnvironment(requestBody, handleSuccess, handleError)
    );
  };

  const modalActions = [
    <Button
      key="add"
      ouiaId="bulk-change-environment-modal-add-button"
      variant="primary"
      onClick={handleConfirm}
      isDisabled={environmentId === null}
      isLoading={environmentsStatus === STATUS.PENDING}
    >
      {__('Change Puppet Environment')}
    </Button>,
    <Button
      key="cancel"
      ouiaId="bulk-change-environment-modal-cancel-button"
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
      title={__('Change Puppet Environment')}
      width="50%"
      position="top"
      actions={modalActions}
      id="bulk-change-puppet-environment"
      key="bulk-change-puppet-environment"
      ouiaId="bulk-change-puppet-environment"
    >
      <TextContent>
        <Text ouiaId="bulk-change-puppet-environment-options">
          {selectAllHostsMode ? (
            <FormattedMessage
              id="bulk-change-puppet-environment-warning-message-all"
              defaultMessage={__(
                'Changing the Puppet environment will affect {boldCount} selected hosts. Some hosts may already have been associated with the selected environment.'
              )}
              values={{
                boldCount: <strong>{__('All')}</strong>,
              }}
            />
          ) : (
            <FormattedMessage
              id="bulk-change-puppet-environment-warning-message"
              defaultMessage={__(
                'Changing the Puppet environment will affect {boldCount} selected {count, plural, one {host} other {hosts}}. Some hosts may already have been associated with the selected environment.'
              )}
              values={{
                count: selectedCount,
                boldCount: <strong>{selectedCount}</strong>,
              }}
            />
          )}
        </Text>
      </TextContent>
      {environmentsStatus === STATUS.RESOLVED && (
        <Select
          id="bulk-change-puppet-environment-select"
          isOpen={environmentSelectOpen}
          selected={environmentId}
          onSelect={handleEnvironmentSelect}
          onOpenChange={isSelectOpen => setEnvironmentSelectOpen(isSelectOpen)}
          toggle={toggle}
          shouldFocusToggleOnSelect
          ouiaId="bulk-change-puppet-environment-select"
        >
          <SelectList>
            <SelectOption value={INHERIT_ENVIRONMENT}>
              {__('*Inherit from host group*')}
            </SelectOption>
            {environments?.results?.map(environment => (
              <SelectOption
                key={`${environment.id}`}
                value={`${environment.id}`}
              >
                {environment.name}
              </SelectOption>
            ))}
          </SelectList>
        </Select>
      )}
    </Modal>
  );
};

BulkChangePuppetEnvironmentModal.propTypes = {
  isOpen: PropTypes.bool,
  closeModal: PropTypes.func,
  fetchBulkParams: PropTypes.func.isRequired,
  selectedCount: PropTypes.number.isRequired,
  selectAllHostsMode: PropTypes.bool.isRequired,
};

BulkChangePuppetEnvironmentModal.defaultProps = {
  isOpen: false,
  closeModal: () => {},
};

export default BulkChangePuppetEnvironmentModal;
