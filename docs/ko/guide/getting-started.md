# 시작하기

`aaa-lint`은 테스트 코드에 **Arrange-Act-Assert** 패턴을 강제하는 lint 플러그인 모음입니다. 각 테스트 블록에는 `arrange`, `act`, `assert` 세 개의 마커 주석이 순서대로 포함되어야 합니다.

```js
it('adds two numbers', () => {
  // arrange
  const a = 1
  const b = 2

  // act
  const sum = a + b

  // assert
  expect(sum).toBe(3)
})
```

## 왜 AAA인가?

AAA 패턴을 따르는 테스트는 읽기 쉽고 수정하기도 쉽습니다. 리뷰어가 준비, 실행, 검증을 한눈에 파악할 수 있고, 작성자에게는 테스트를 작고 집중된 상태로 유지하도록 자연스럽게 유도합니다.

`aaa-lint`는 이 관습을 기계적인 검사로 바꿔 주므로, 코드 리뷰 피로나 인원 교체에도 견뎌냅니다.

## 지원 언어

| 언어 | Linter | 패키지 |
|---|---|---|
| JavaScript / TypeScript | [ESLint](https://eslint.org/) | [`eslint-plugin-aaa`](./eslint) |
| Ruby | [RuboCop](https://rubocop.org/) | [`rubocop-aaa`](./rubocop) |
| PHP | [PHP_CodeSniffer](https://github.com/PHPCSStandards/PHP_CodeSniffer) | [`phpcs-aaa`](./phpcs) |

세 가지 구현 모두 동일한 옵션 (`labels`, `testFunctions`, `caseSensitive`, `allowEmptySection`)을 공유하므로 여러 언어를 사용하는 프로젝트에서도 설정을 통일할 수 있습니다.

## 라벨 커스터마이즈

기본 라벨은 영어 `arrange`, `act`, `assert`입니다. 원하는 언어나 스타일로 덮어쓸 수 있습니다.

```jsonc
{
  "labels": {
    "arrange": ["given"],
    "act":     ["when"],
    "assert":  ["then"]
  }
}
```

각 섹션마다 여러 표기를 허용할 수 있으므로, 팀 내 표현이 약간씩 다를 때 편리합니다.

```jsonc
{
  "labels": {
    "arrange": ["준비", "사전준비"],
    "act":     ["실행"],
    "assert":  ["검증", "확인"]
  }
}
```

## 다음 단계

사용 중인 스택에 맞는 플러그인의 설정 가이드를 확인하세요.

- [ESLint](./eslint)
- [RuboCop](./rubocop)
- [PHP_CodeSniffer](./phpcs)
