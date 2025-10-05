import { pageTitle } from 'ember-page-title';

import TypingChallenge from '../components/typing-challenge.gts';

<template>
  {{pageTitle "JS Typing Challenge"}}

  <TypingChallenge />
  {{outlet}}
</template>
