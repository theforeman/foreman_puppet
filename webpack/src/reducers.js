import { combineReducers } from 'redux';
import EmptyStateReducer from './Components/EmptyState/EmptyStateReducer';

const reducers = {
  foremanPuppetEnc: combineReducers({
    emptyState: EmptyStateReducer,
  }),
};

export default reducers;
