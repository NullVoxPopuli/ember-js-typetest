import { pageTitle } from 'ember-page-title';

<template>
  {{pageTitle "404 - Page Not Found | JS Typing Challenge"}}

  <div class="not-found-page">
    <div class="not-found-container">
      <div class="error-code">404</div>
      <div class="error-message">
        <h1 class="error-title">Page Not Found</h1>
        <p class="error-description">
          The page you're looking for doesn't exist in this synthwave dimension.
        </p>
      </div>

      <div class="error-actions">
        <a href="/" class="home-btn">
          🏠 Return to Challenge
        </a>
        <a href="/" class="random-test-btn">
          🎲 Start Random Test
        </a>
      </div>

      <div class="error-graphic">
        <div class="glitch-text">
          <span class="glitch-layer">ERROR</span>
          <span class="glitch-layer">ERROR</span>
          <span class="glitch-layer">ERROR</span>
        </div>
      </div>
    </div>
  </div>
</template>
