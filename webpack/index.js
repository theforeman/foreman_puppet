/* eslint import/no-unresolved: [2, { ignore: [foremanReact/*] }] */
/* eslint-disable import/no-extraneous-dependencies */
/* eslint-disable import/extensions */
import componentRegistry from 'foremanReact/components/componentRegistry';
import { registerReducer } from 'foremanReact/common/MountingService';
import reducers from './src/reducers';
import ForemanPuppet from './src/ForemanPuppet';
import { WelcomeEnv } from './src/Components/Environments/Welcome';

// register reducers
Object.entries(reducers).forEach(([key, reducer]) =>
  registerReducer(key, reducer)
);

// register components for erb mounting
componentRegistry.register({ name: 'WelcomeEnv', type: WelcomeEnv });
componentRegistry.register({ name: 'ForemanPuppet', type: ForemanPuppet });
