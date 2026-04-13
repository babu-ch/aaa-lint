# ESLint (JS / TS)

`eslint-plugin-aaa-pattern`는 JavaScript / TypeScript 테스트 파일에 Arrange-Act-Assert 패턴을 강제합니다.

## 설치

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

번들된 권장 설정을 사용하려면:

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

## 규칙: `aaa/pattern`

### 옵션

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

| 옵션 | 기본값 | 설명 |
|---|---|---|
| `labels` | 영어 기본 | 각 섹션에서 허용할 주석 텍스트. 배열이므로 동의어를 여러 개 등록할 수 있습니다. |
| `testFunctions` | `["it", "test"]` | 검사 대상 테스트 정의 함수. 필요 시 `"specify"`, `"example"` 등을 추가하세요. |
| `caseSensitive` | `false` | `false`이면 `// ARRANGE`와 `arrange`가 동일하게 처리됩니다. |
| `allowEmptySection` | `true` | `false`로 설정하면 섹션에 코드가 없을 때도 오류를 보고합니다. |

### 예시

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

#### 한국어

```jsonc
{
  "labels": {
    "arrange": ["준비", "사전준비"],
    "act":     ["실행"],
    "assert":  ["검증", "확인"]
  }
}
```

### 감지 예시

```js
// 오류: "arrange" 주석 누락
it('bad', () => {
  // act
  const x = doThing()
  // assert
  expect(x).toBe(1)
})

// 오류: 순서가 잘못됨
it('also bad', () => {
  // act
  const x = doThing()
  // arrange
  const y = 1
  // assert
  expect(x).toBe(y)
})
```
