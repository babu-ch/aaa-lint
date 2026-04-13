# ESLint (JS / TS)

`eslint-plugin-aaa` enforces the Arrange-Act-Assert pattern in JavaScript and TypeScript test files.

## Install

```bash
npm install --save-dev eslint-plugin-aaa
```

## Flat config (ESLint v9+)

```js
// eslint.config.js
import aaa from 'eslint-plugin-aaa'

export default [
  {
    files: ['**/*.test.{js,ts}'],
    plugins: { aaa },
    rules: {
      'aaa/pattern': 'error'
    }
  }
]
```

Or use the bundled recommended config:

```js
import aaa from 'eslint-plugin-aaa'

export default [aaa.configs.recommended]
```

## Legacy config (ESLint v8)

```jsonc
// .eslintrc.json
{
  "plugins": ["aaa"],
  "overrides": [
    {
      "files": ["**/*.test.js"],
      "rules": { "aaa/pattern": "error" }
    }
  ]
}
```

## Rule: `aaa/pattern`

### Options

```jsonc
{
  "aaa/pattern": ["error", {
    "labels": {
      "arrange": ["arrange"],
      "act":     ["act"],
      "assert":  ["assert"]
    },
    "testFunctions": ["it", "test"],
    "caseSensitive": false,
    "allowEmptySection": true
  }]
}
```

| Option | Default | Description |
|---|---|---|
| `labels` | English defaults | Accepted comment text for each section. Each value is an array, so multiple synonyms are fine. |
| `testFunctions` | `["it", "test"]` | Test-defining calls to inspect. Add `"specify"`, `"example"`, etc. as needed. |
| `caseSensitive` | `false` | If `false`, label matching ignores case (`// ARRANGE` matches `arrange`). |
| `allowEmptySection` | `true` | If `false`, reports when a section has no statements between its comment and the next. |

### Examples

#### Given / When / Then

```jsonc
{
  "labels": {
    "arrange": ["given"],
    "act":     ["when"],
    "assert":  ["then"]
  }
}
```

#### Japanese

```jsonc
{
  "labels": {
    "arrange": ["準備", "前準備"],
    "act":     ["実行"],
    "assert":  ["検証", "確認"]
  }
}
```

### What it catches

```js
// Error: missing "arrange" comment
it('bad', () => {
  // act
  const x = doThing()
  // assert
  expect(x).toBe(1)
})

// Error: wrong order
it('also bad', () => {
  // act
  const x = doThing()
  // arrange
  const y = 1
  // assert
  expect(x).toBe(y)
})
```
