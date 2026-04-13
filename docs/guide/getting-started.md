# Getting Started

`aaa-lint` is a family of lint plugins that enforce the **Arrange-Act-Assert** pattern in your test code. Every test block must contain three marker comments — `arrange`, `act`, `assert` — in that exact order.

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

## Why AAA?

Tests that follow the AAA pattern are easier to read and easier to modify. Reviewers can locate the setup, the action under test, and the expectations at a glance. The pattern also nudges authors to keep tests small and focused.

`aaa-lint` turns this convention into a mechanical check so it survives code review fatigue and onboarding turnover.

## Supported languages

| Language | Linter | Package |
|---|---|---|
| JavaScript / TypeScript | [ESLint](https://eslint.org/) | [`eslint-plugin-aaa`](./eslint) |
| Ruby | [RuboCop](https://rubocop.org/) | [`rubocop-aaa`](./rubocop) |
| PHP | [PHP_CodeSniffer](https://github.com/PHPCSStandards/PHP_CodeSniffer) | [`phpcs-aaa`](./phpcs) |

All three implementations share the same option surface (`labels`, `testFunctions`, `caseSensitive`, `allowEmptySection`) so projects that mix languages can keep their configuration consistent.

## Customizing labels

The default labels are English — `arrange`, `act`, `assert`. You can override them for any language or style:

```jsonc
{
  "labels": {
    "arrange": ["given"],
    "act":     ["when"],
    "assert":  ["then"]
  }
}
```

Multiple accepted spellings per section are supported, which is handy when team members naturally write slightly different wording:

```jsonc
{
  "labels": {
    "arrange": ["準備", "前準備"],
    "act":     ["実行"],
    "assert":  ["検証", "確認"]
  }
}
```

## Next steps

Pick the plugin for your stack and follow its setup guide:

- [ESLint](./eslint)
- [RuboCop](./rubocop)
- [PHP_CodeSniffer](./phpcs)
