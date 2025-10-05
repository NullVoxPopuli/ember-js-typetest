import { pageTitle } from 'ember-page-title';

import TypingChallenge from '../components/typing-challenge.gts';

<template>
  {{pageTitle @model}}

  <TypingChallenge @snippet={{@model}} />
</template>
