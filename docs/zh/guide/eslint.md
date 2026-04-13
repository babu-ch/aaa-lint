# ESLint (JS / TS)

`eslint-plugin-aaa` 在 JavaScript / TypeScript 测试文件中强制执行 Arrange-Act-Assert 模式。

## 安装

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

或使用内置的推荐配置:

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

## 规则: `aaa/pattern`

### 选项

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

| 选项 | 默认值 | 说明 |
|---|---|---|
| `labels` | 英文默认 | 每个部分允许的注释文本。数组形式,可注册多个同义词。 |
| `testFunctions` | `["it", "test"]` | 被检查的测试定义函数。按需追加 `"specify"`、`"example"` 等。 |
| `caseSensitive` | `false` | 为 `false` 时 `// ARRANGE` 与 `arrange` 等价。 |
| `allowEmptySection` | `true` | 为 `false` 时,某部分内无语句则报错。 |

### 示例

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

#### 中文

```jsonc
{
  "labels": {
    "arrange": ["准备", "前期准备"],
    "act":     ["执行"],
    "assert":  ["验证", "断言"]
  }
}
```

### 检测示例

```js
// 错误: 缺少 "arrange" 注释
it('bad', () => {
  // act
  const x = doThing()
  // assert
  expect(x).toBe(1)
})

// 错误: 顺序错误
it('also bad', () => {
  // act
  const x = doThing()
  // arrange
  const y = 1
  // assert
  expect(x).toBe(y)
})
```
