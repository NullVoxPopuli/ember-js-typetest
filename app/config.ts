// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
import { getGlobalConfig } from '@embroider/macros/src/addon/runtime';

const ENV = {
  environment: import.meta.env.DEV ? 'development' : 'production',
  rootURL: '/ember-js-typetest/',
  locationType: 'history',
  EmberENV: {},
  APP: {},
} as {
  environment: string;
  locationType: 'history' | 'hash' | 'none' | 'auto';
  rootURL: string;
  EmberENV: Record<string, unknown>;
  APP: Record<string, unknown>;
  SERVICE_WORKER: boolean;
};

export default ENV;

export function enterTestMode() {
  ENV.locationType = 'none';
  ENV.APP.rootElement = '#ember-testing';
  ENV.APP.autoboot = false;

  // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-assignment
  const config = getGlobalConfig()['@embroider/macros'];

  // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
  if (config) config.isTesting = true;
}
