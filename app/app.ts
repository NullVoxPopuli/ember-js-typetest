import PageTitleService from 'ember-page-title/services/page-title';
import Application from 'ember-strict-application-resolver';

export default class App extends Application {
  modules = {
    ...import.meta.glob('./routes/**/*', { eager: true }),
    ...import.meta.glob('./templates/**/*', { eager: true }),
    './services/page-title': PageTitleService,
  };
}
