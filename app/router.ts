import EmberRouter from '@embroider/router';

import config from '#config';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('test', { path: '/test/:snippet_id' });
});
