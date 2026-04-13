'use strict'

const pkg = require('../package.json')
const pattern = require('./rules/pattern')

const plugin = {
  meta: {
    name: pkg.name,
    version: pkg.version,
  },
  rules: {
    pattern,
  },
}

plugin.configs = {
  recommended: {
    plugins: { aaa: plugin },
    rules: {
      'aaa/pattern': 'error',
    },
  },
  'recommended-legacy': {
    plugins: ['aaa'],
    rules: {
      'aaa/pattern': 'error',
    },
  },
}

module.exports = plugin
