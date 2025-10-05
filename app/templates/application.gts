import { pageTitle } from 'ember-page-title';

import TypingChallenge from '../components/typing-challenge.gts';

<template>
  {{pageTitle "Synthwave Typing Challenge"}}

  <TypingChallenge />
  {{outlet}}
</template>
