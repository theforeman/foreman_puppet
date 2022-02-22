import { registerReducer } from 'foremanReact/common/MountingService';
import reducers from './src/reducers';
import { registerFills } from './src/Extends/Fills';
import { registerLegacy } from './legacy';

// register reducers
registerReducer('puppet', reducers);
// add fills
registerFills();
// TODO: the checkForUnavailablePuppetclasses is very nasty
registerLegacy();
