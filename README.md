# aaa-lint

Multi-language lint plugins that enforce the **AAA (Arrange-Act-Assert)** pattern in test code.

Each plugin checks that every test block contains three section-marker comments — `arrange`, `act`, `assert` — in that exact order.

```js
it('adds two numbers', () => {
  // arrange
  const a = 1
  const b = 2

  // act
  const sum = add(a, b)

  // assert
  expect(sum).toBe(3)
})
```

## Packages

| Language | Linter | Package | Status |
|---|---|---|---|
| JS / TS | ESLint | [`eslint-plugin-aaa`](./packages/eslint-plugin-aaa) | WIP |
| Ruby | RuboCop | [`rubocop-aaa`](./packages/rubocop-aaa) | WIP |
| PHP | PHP_CodeSniffer | [`phpcs-aaa`](./packages/phpcs-aaa) | WIP |

## Customizing labels

There is no built-in preset besides the English default. Use the `labels` option to switch to GWT, Japanese, or any other wording:

```jsonc
{
  "labels": {
    "arrange": ["given"],
    "act":     ["when"],
    "assert":  ["then"]
  }
}
```

## License

MIT
