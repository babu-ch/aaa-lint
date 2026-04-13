# aaa-lint

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/babu-ch/aaa-lint)

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
| JS / TS | ESLint | [`eslint-plugin-aaa-pattern`](./packages/eslint-plugin-aaa-pattern) | WIP |
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

## Documentation

Full docs (English / 日本語 / 中文 / 한국어 / Español / Français / Deutsch / Português): <https://babu-ch.github.io/aaa-lint/>

## Development

All tests run inside Docker — no local Node/Ruby/PHP installs required. See [DEVELOPMENT.md](./DEVELOPMENT.md).

```bash
make test          # run all three language suites
```

## Releasing

See [RELEASE.md](./RELEASE.md). The PHP package ships through a split mirror at <https://github.com/babu-ch/phpcs-aaa> driven by `scripts/release-phpcs.sh`.

## License

MIT
