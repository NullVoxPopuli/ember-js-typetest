import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';

import { getRandomSnippet } from '../data/code-snippets.ts';

import type RouterService from '@ember/routing/router-service';

export default class IndexRoute extends Route {
  @service declare router: RouterService;

  beforeModel() {
    // Get a random snippet and redirect to the test route with its ID
    const snippet = getRandomSnippet();

    this.router.transitionTo('test', snippet.id);
  }
}
