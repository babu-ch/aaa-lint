# はじめに

`aaa-lint` は、テストコードで **Arrange-Act-Assert** パターンを強制する lint プラグイン群です。各テストブロック内に `arrange` / `act` / `assert` の3つのマーカーコメントがこの順序で存在することをチェックします。

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

## なぜ AAA?

AAA パターンに従ったテストは読みやすく、修正しやすくなります。レビュー時に「準備」「実行」「検証」を一目で見分けられ、テスト作者にとっても1つの関心に集中する後押しになります。

`aaa-lint` はこの慣習を機械的なチェックに落とし込むので、コードレビューの疲労やメンバー交代にも耐えます。

## 対応言語

| 言語 | Linter | パッケージ |
|---|---|---|
| JavaScript / TypeScript | [ESLint](https://eslint.org/) | [`eslint-plugin-aaa-pattern`](./eslint) |
| Ruby | [RuboCop](https://rubocop.org/) | [`rubocop-aaa`](./rubocop) |
| PHP | [PHP_CodeSniffer](https://github.com/PHPCSStandards/PHP_CodeSniffer) | [`phpcs-aaa`](./phpcs) |

3つのプラグインは同じオプション (`labels` / `testFunctions` / `caseSensitive` / `allowEmptySection`) を共有するので、複数言語を扱うプロジェクトでも設定を揃えやすくなっています。

## ラベルのカスタマイズ

デフォルトのラベルは英語 (`arrange` / `act` / `assert`) ですが、好みの言葉に差し替えられます。

```jsonc
{
  "labels": {
    "arrange": ["given"],
    "act":     ["when"],
    "assert":  ["then"]
  }
}
```

各セクションに複数の表記を登録できるので、チーム内で揺れる言い回しをすべて受け入れる運用もできます。

```jsonc
{
  "labels": {
    "arrange": ["準備", "前準備"],
    "act":     ["実行"],
    "assert":  ["検証", "確認"]
  }
}
```

## 次のステップ

使っているスタックに合わせてセットアップガイドへ進んでください。

- [ESLint](./eslint)
- [RuboCop](./rubocop)
- [PHP_CodeSniffer](./phpcs)
