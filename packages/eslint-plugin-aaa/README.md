# eslint-plugin-aaa

Enforce the **Arrange-Act-Assert** pattern in test code via ESLint.

## Install

```bash
npm install --save-dev eslint-plugin-aaa
```

## Usage

### Flat config (ESLint v9+)

```js
// eslint.config.js
import aaa from 'eslint-plugin-aaa'

export default [
  {
    files: ['**/*.test.{js,ts}'],
    plugins: { aaa },
    rules: {
      'aaa/pattern': 'error',
    },
  },
]
```

Or use the bundled recommended config:

```js
import aaa from 'eslint-plugin-aaa'

export default [aaa.configs.recommended]
```

### Legacy config (ESLint v8)

```jsonc
// .eslintrc.json
{
  "plugins": ["aaa"],
  "overrides": [
    {
      "files": ["**/*.test.js"],
      "rules": {
        "aaa/pattern": "error"
      }
    }
  ]
}
```

## Rule: `aaa/pattern`

Checks that every test block contains three marker comments — `arrange`, `act`, `assert` — in that order.

```js
it('adds', () => {
  // arrange
  const a = 1
  const b = 2

  // act
  const sum = a + b

  // assert
  expect(sum).toBe(3)
})
```

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
| `labels` | `{ arrange: ["arrange"], act: ["act"], assert: ["assert"] }` | Accepted comment text for each section. Any match in the array is accepted. |
| `testFunctions` | `["it", "test"]` | Names of test-defining calls to inspect. |
| `caseSensitive` | `false` | If `false`, label matching ignores case. |
| `allowEmptySection` | `true` | If `false`, report when a section has no statements between its comment and the next. |

### Customizing labels

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

Because Japanese phrasing varies (準備 vs 前準備, 検証 vs 確認), the plugin ships no Japanese preset — list the wording your team actually uses:

```jsonc
{
  "labels": {
    "arrange": ["準備", "前準備"],
    "act":     ["実行"],
    "assert":  ["検証", "確認"]
  }
}
```

## License

MIT
