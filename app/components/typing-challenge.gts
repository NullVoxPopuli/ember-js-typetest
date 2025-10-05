import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';

import type { CodeSnippet } from '../data/code-snippets.ts';
import type Owner from '@ember/owner';
import type RouterService from '@ember/routing/router-service';

interface TypingStats {
  wpm: number;
  accuracy: number;
  timeElapsed: number;
  totalCharacters: number;
  correctCharacters: number;
  errors: number;
}

interface Signature {
  Args: {
    snippet: CodeSnippet;
  };
}

function isNewline(char: string) {
  return char === '\n';
}

export default class TypingChallengeComponent extends Component<Signature> {
  @service declare router: RouterService;

  @tracked userInput = '';
  @tracked isActive = false;
  @tracked isCompleted = false;
  @tracked startTime: number | null = null;
  @tracked endTime: number | null = null;
  @tracked currentCharIndex = 0;
  @tracked stats: TypingStats | null = null;

  get currentSnippet(): CodeSnippet {
    return this.args.snippet;
  }

  constructor(owner: Owner, args: { snippet: CodeSnippet }) {
    super(owner, args);
    this.setupEventListeners();
  }

  willDestroy() {
    super.willDestroy();
    this.removeEventListeners();
  }

  setupEventListeners(): void {
    document.addEventListener('keydown', this.handleDocumentKeyDown);
  }

  removeEventListeners(): void {
    document.removeEventListener('keydown', this.handleDocumentKeyDown);
  }

  handleDocumentKeyDown = (event: KeyboardEvent): void => {
    // Skip if test is completed
    if (this.isCompleted) return;

    // Skip if focusing on an input element
    const target = event.target as HTMLElement;

    if (target.tagName === 'INPUT' || target.tagName === 'TEXTAREA') return;

    // Prevent certain actions that could break the test
    if (event.ctrlKey || event.metaKey) {
      if (['a', 'c', 'v', 'x', 'z', 'y'].includes(event.key.toLowerCase())) {
        event.preventDefault();
      }

      return;
    }

    // Handle backspace
    if (event.key === 'Backspace') {
      event.preventDefault();

      if (this.userInput.length > 0) {
        this.userInput = this.userInput.slice(0, -1);
        this.currentCharIndex = this.userInput.length;
      }

      return;
    }

    // Handle Enter key as newline
    if (event.key === 'Enter') {
      event.preventDefault();

      // Don't allow input beyond target length
      if (this.userInput.length >= this.targetCode.length) {
        return;
      }

      // Start the timer on first character
      if (!this.isActive && this.userInput.length === 0) {
        this.isActive = true;
        this.startTime = Date.now();
      }

      this.userInput = this.userInput + '\n';
      this.currentCharIndex = this.userInput.length;

      // Check if test is complete
      if (this.isTestComplete) {
        this.completeTest();
      }

      return;
    }

    // Handle printable characters
    if (event.key.length === 1) {
      event.preventDefault();

      // Don't allow input beyond target length
      if (this.userInput.length >= this.targetCode.length) {
        return;
      }

      // Start the timer on first character
      if (!this.isActive && this.userInput.length === 0) {
        this.isActive = true;
        this.startTime = Date.now();
      }

      this.userInput = this.userInput + event.key;
      this.currentCharIndex = this.userInput.length;

      // Check if test is complete
      if (this.isTestComplete) {
        this.completeTest();
      }
    }
  };

  get targetCode(): string {
    return this.currentSnippet.code;
  }

  get displayChars(): Array<{
    char: string;
    status: 'correct' | 'incorrect' | 'current' | 'pending';
  }> {
    const targetChars = this.targetCode.split('');
    const inputChars = this.userInput.split('');

    return targetChars.map((char, index) => {
      if (index < inputChars.length) {
        const status = inputChars[index] === char ? 'correct' : 'incorrect';

        return { char, status };
      } else if (index === this.currentCharIndex) {
        return { char, status: 'current' };
      } else {
        return { char, status: 'pending' };
      }
    });
  }

  get isTestComplete(): boolean {
    return this.userInput.length === this.targetCode.length;
  }

  @action
  completeTest(): void {
    if (this.isCompleted || !this.startTime) return;

    this.isCompleted = true;
    this.isActive = false;
    this.endTime = Date.now();
    this.stats = this.calculateStats();
  }

  calculateStats(): TypingStats {
    if (!this.startTime || !this.endTime) {
      throw new Error('Cannot calculate stats without start and end times');
    }

    const timeElapsed = (this.endTime - this.startTime) / 1000; // seconds
    const totalCharacters = this.targetCode.length;
    const inputChars = this.userInput.split('');
    const targetChars = this.targetCode.split('');

    let correctCharacters = 0;
    let errors = 0;

    for (let i = 0; i < Math.min(inputChars.length, targetChars.length); i++) {
      if (inputChars[i] === targetChars[i]) {
        correctCharacters++;
      } else {
        errors++;
      }
    }

    const accuracy =
      totalCharacters > 0 ? (correctCharacters / totalCharacters) * 100 : 0;

    // WPM calculation: (correct characters / 5) / (time in minutes)
    const timeInMinutes = timeElapsed / 60;
    const wpm =
      timeInMinutes > 0 ? Math.round(correctCharacters / 5 / timeInMinutes) : 0;

    return {
      wpm,
      accuracy: Math.round(accuracy * 10) / 10, // Round to 1 decimal place
      timeElapsed: Math.round(timeElapsed * 10) / 10,
      totalCharacters,
      correctCharacters,
      errors,
    };
  }

  @action
  restart(): void {
    // Navigate back to index route to get a new random snippet
    this.router.transitionTo('index');
  }

  <template>
    <div class="typing-challenge">
      <div class="challenge-header">
        <h1 class="challenge-title">JavaScript Typing Challenge</h1>
        <p class="challenge-description">Type the JavaScript code as fast and
          accurately as you can!</p>
      </div>

      {{#unless this.isCompleted}}
        <div class="code-display">
          <div class="snippet-info">
            <span
              class="snippet-label"
            >{{this.currentSnippet.description}}</span>
          </div>

          <div class="code-text">
            {{#each this.displayChars as |charObj|}}
              {{#if (isNewline charObj.char)}}
                <span
                  class="char char--{{charObj.status}} char--newline"
                >{{charObj.char}}</span>
              {{else}}
                <span
                  class="char char--{{charObj.status}}"
                >{{charObj.char}}</span>
              {{/if}}
            {{/each}}
          </div>
        </div>

        <div class="new-test-section">
          <a href="/" class="new-test-btn">
            🎲 Pick New Random Test
          </a>
        </div>

        {{#unless this.isActive}}
          <div class="typing-hint">
            <p class="hint-text">✨ Start typing anywhere to begin the
              challenge! ✨</p>
            <p class="hint-subtext">No need to click or focus - just start
              typing</p>
          </div>
        {{/unless}}

        {{#if this.isActive}}
          <div class="status-bar">
            <div class="progress-indicator">
              Progress:
              {{this.currentCharIndex}}/{{this.targetCode.length}}
            </div>
          </div>
        {{/if}}
      {{/unless}}

      {{#if this.isCompleted}}
        <div class="results-screen">
          <h2 class="results-title">Challenge Complete!</h2>

          {{#if this.stats}}
            <div class="stats-grid">
              <div class="stat-item stat-item--primary">
                <div class="stat-value">{{this.stats.wpm}}</div>
                <div class="stat-label">WPM</div>
              </div>

              <div class="stat-item">
                <div class="stat-value">{{this.stats.accuracy}}%</div>
                <div class="stat-label">Accuracy</div>
              </div>

              <div class="stat-item">
                <div class="stat-value">{{this.stats.timeElapsed}}s</div>
                <div class="stat-label">Time</div>
              </div>

              <div class="stat-item">
                <div class="stat-value">{{this.stats.errors}}</div>
                <div class="stat-label">Errors</div>
              </div>
            </div>
          {{/if}}

          <button class="restart-btn" type="button" {{on "click" this.restart}}>
            Try Another Challenge
          </button>
        </div>
      {{/if}}
    </div>
  </template>
}
