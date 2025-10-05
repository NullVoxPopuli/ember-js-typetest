import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';

import { CODE_SNIPPETS, type CodeSnippet } from '../data/code-snippets.ts';

import type RouterService from '@ember/routing/router-service';

export default class TestRoute extends Route {
  @service declare router: RouterService;

  model(params: Record<string, unknown>): CodeSnippet {
    const snippetIdParam = params.snippet_id;

    if (typeof snippetIdParam !== 'string') {
      this.router.transitionTo('index');
      throw new Error('Invalid snippet ID parameter');
    }

    const snippet = CODE_SNIPPETS.find((s) => s.id === snippetIdParam);

    if (!snippet) {
      // If snippet not found, redirect back to index to get a new one
      this.router.transitionTo('index');
      throw new Error(`Snippet with ID ${snippetIdParam} not found`);
    }

    return snippet;
  }
}
