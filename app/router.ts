import EmberRouter from '@embroider/router';

import { properLinks } from 'ember-primitives/proper-links';

import config from '#config';

@properLinks
export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('test', { path: '/test/:snippet_id' });
  this.route('not-found', { path: '/*path' });
});
