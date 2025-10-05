import { pageTitle } from 'ember-page-title';

import TypingChallenge from '../components/typing-challenge.gts';

import type { CodeSnippet } from '../data/code-snippets.ts';
import type { TOC } from '@ember/component/template-only';

<template>
  {{pageTitle @model.id}}

  {{! This gets us around an optimization that
    ember did long ago that no one likes anymore,
    where components are re-used when only params on a route changes
    but the route itself doesn't change.
  }}
  {{#each (Array @model) as |hack|}}
    <TypingChallenge @snippet={{hack}} />
  {{/each}}
</template> satisfies TOC<{
  Args: {
    model: CodeSnippet;
  };
}>;
