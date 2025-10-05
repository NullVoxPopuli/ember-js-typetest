import PageTitleService from 'ember-page-title/services/page-title';
import Application from 'ember-strict-application-resolver';

import Router from './router';

export default class App extends Application {
  modules = {
    './router': Router,
    ...import.meta.glob('./routes/**/*', { eager: true }),
    ...import.meta.glob('./templates/**/*', { eager: true }),
    './services/page-title': PageTitleService,
  };
}
