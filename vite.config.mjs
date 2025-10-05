import { defineConfig } from 'vite';
import { extensions, ember } from '@embroider/vite';
import { babel } from '@rollup/plugin-babel';

export default defineConfig({
  // To match:
  // https://nullvoxpopuli.github.io/ember-js-typetest/
  base: '/ember-js-typetest/',
  plugins: [
    ember(),
    // extra plugins here
    babel({
      babelHelpers: 'runtime',
      extensions,
    }),
  ],
});
