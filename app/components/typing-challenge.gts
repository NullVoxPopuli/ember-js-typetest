import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { action } from '@ember/object';

import { type CodeSnippet,getRandomSnippet } from '../data/code-snippets.ts';

interface TypingStats {
  wpm: number;
  accuracy: number;
  timeElapsed: number;
  totalCharacters: number;
  correctCharacters: number;
  errors: number;
}

export default class TypingChallengeComponent extends Component {
  @tracked currentSnippet: CodeSnippet = getRandomSnippet();
  @tracked userInput = '';
  @tracked isActive = false;
  @tracked isCompleted = false;
  @tracked startTime: number | null = null;
  @tracked endTime: number | null = null;
  @tracked currentCharIndex = 0;
  @tracked stats: TypingStats | null = null;

  get targetCode(): string {
    return this.currentSnippet.code;
  }

  get displayChars(): Array<{ char: string; status: 'correct' | 'incorrect' | 'current' | 'pending' }> {
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
  handleInput(event: Event): void {
    const input = event.target as HTMLTextAreaElement;
    const value = input.value;

    // Don't allow input beyond target length
    if (value.length > this.targetCode.length) {
      return;
    }

    // Start the timer on first character
    if (!this.isActive && value.length > 0) {
      this.isActive = true;
      this.startTime = Date.now();
    }

    this.userInput = value;
    this.currentCharIndex = value.length;

    // Check if test is complete
    if (this.isTestComplete) {
      this.completeTest();
    }
  }

  @action
  handleKeyDown(event: KeyboardEvent): void {
    // Prevent certain actions that could break the test
    if (event.ctrlKey || event.metaKey) {
      if (['a', 'c', 'v', 'x', 'z', 'y'].includes(event.key.toLowerCase())) {
        event.preventDefault();
      }
    }
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

    const accuracy = totalCharacters > 0 ? (correctCharacters / totalCharacters) * 100 : 0;

    // WPM calculation: (correct characters / 5) / (time in minutes)
    const timeInMinutes = timeElapsed / 60;
    const wpm = timeInMinutes > 0 ? Math.round((correctCharacters / 5) / timeInMinutes) : 0;

    return {
      wpm,
      accuracy: Math.round(accuracy * 10) / 10, // Round to 1 decimal place
      timeElapsed: Math.round(timeElapsed * 10) / 10,
      totalCharacters,
      correctCharacters,
      errors
    };
  }

  @action
  restart(): void {
    this.currentSnippet = getRandomSnippet();
    this.userInput = '';
    this.isActive = false;
    this.isCompleted = false;
    this.startTime = null;
    this.endTime = null;
    this.currentCharIndex = 0;
    this.stats = null;
  }

  <template>
    <div class="typing-challenge">
      <div class="challenge-header">
        <h1 class="challenge-title">Synthwave Typing Challenge</h1>
        <p class="challenge-description">Type the JavaScript code as fast and accurately as you can!</p>
      </div>

      {{#unless this.isCompleted}}
        <div class="code-display">
          <div class="snippet-info">
            <span class="snippet-label">{{this.currentSnippet.description}}</span>
          </div>

          <div class="code-text">
            {{#each this.displayChars as |charObj|}}
              <span class="char char--{{charObj.status}}">{{charObj.char}}</span>
            {{/each}}
          </div>
        </div>

        <div class="input-section">
          <label for="typing-input" class="sr-only">Type the code here</label>
          <textarea
            id="typing-input"
            class="typing-input"
            value={{this.userInput}}
            placeholder="Start typing to begin the challenge..."
            spellcheck="false"
            autocomplete="off"
            autocorrect="off"
            autocapitalize="off"
            {{on "input" this.handleInput}}
            {{on "keydown" this.handleKeyDown}}
          ></textarea>
        </div>

        {{#if this.isActive}}
          <div class="status-bar">
            <div class="progress-indicator">
              Progress: {{this.currentCharIndex}}/{{this.targetCode.length}}
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

          <button
            class="restart-btn"
            type="button"
            {{on "click" this.restart}}
          >
            Try Another Challenge
          </button>
        </div>
      {{/if}}
    </div>
  </template>
}

