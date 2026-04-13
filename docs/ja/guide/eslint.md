# ESLint (JS / TS)

`eslint-plugin-aaa-pattern` は、JavaScript / TypeScript のテストファイルに対して Arrange-Act-Assert パターンを強制します。

## インストール

```bash
npm install --save-dev eslint-plugin-aaa-pattern
```

## Flat config (ESLint v9+)

```js
// eslint.config.js
import aaa from 'eslint-plugin-aaa-pattern'

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

同梱の推奨設定を使う場合:

```js
import aaa from 'eslint-plugin-aaa-pattern'

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

## ルール: `aaa/pattern`

### オプション

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

| オプション | デフォルト | 説明 |
|---|---|---|
| `labels` | 英語のデフォルト | 各セクションで許可するコメント文字列。配列なので同義語を複数登録できます。 |
| `testFunctions` | `["it", "test"]` | 検査対象のテスト定義関数。必要に応じて `"specify"` / `"example"` などを追加してください。 |
| `caseSensitive` | `false` | `false` のとき `// ARRANGE` と `arrange` は同一視されます。 |
| `allowEmptySection` | `true` | `false` にすると、セクション内にコードが無い場合もエラーになります。 |

### 例

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

#### 日本語

```jsonc
{
  "labels": {
    "arrange": ["準備", "前準備"],
    "act":     ["実行"],
    "assert":  ["検証", "確認"]
  }
}
```

### 検出例

```js
// エラー: "arrange" コメントが無い
it('bad', () => {
  // act
  const x = doThing()
  // assert
  expect(x).toBe(1)
})

// エラー: 順序が逆
it('also bad', () => {
  // act
  const x = doThing()
  // arrange
  const y = 1
  // assert
  expect(x).toBe(y)
})
```
