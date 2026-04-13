# Erste Schritte

`aaa-lint` ist eine Familie von Lint-Plugins, die das **Arrange-Act-Assert**-Muster im Testcode erzwingen. Jeder Testblock muss drei Marker-Kommentare enthalten — `arrange`, `act`, `assert` — in genau dieser Reihenfolge.

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

## Warum AAA?

Tests, die dem AAA-Muster folgen, sind leichter zu lesen und zu ändern. Reviewer erkennen Vorbereitung, getestete Aktion und Erwartungen auf einen Blick. Das Muster motiviert Autoren auch, Tests klein und fokussiert zu halten.

`aaa-lint` verwandelt diese Konvention in eine mechanische Prüfung, sodass sie Review-Müdigkeit und Personalwechsel übersteht.

## Unterstützte Sprachen

| Sprache | Linter | Paket |
|---|---|---|
| JavaScript / TypeScript | [ESLint](https://eslint.org/) | [`eslint-plugin-aaa`](./eslint) |
| Ruby | [RuboCop](https://rubocop.org/) | [`rubocop-aaa`](./rubocop) |
| PHP | [PHP_CodeSniffer](https://github.com/PHPCSStandards/PHP_CodeSniffer) | [`phpcs-aaa`](./phpcs) |

Alle drei Implementierungen teilen dieselben Optionen (`labels`, `testFunctions`, `caseSensitive`, `allowEmptySection`), sodass Projekte mit mehreren Sprachen eine einheitliche Konfiguration behalten können.

## Labels anpassen

Die Standard-Labels sind englisch: `arrange`, `act`, `assert`. Sie lassen sich für jede Sprache oder jeden Stil überschreiben:

```jsonc
{
  "labels": {
    "arrange": ["given"],
    "act":     ["when"],
    "assert":  ["then"]
  }
}
```

Mehrere Schreibweisen pro Sektion sind erlaubt, nützlich wenn Teammitglieder leicht unterschiedliche Wörter verwenden:

```jsonc
{
  "labels": {
    "arrange": ["vorbereiten", "gegeben"],
    "act":     ["ausführen"],
    "assert":  ["prüfen", "erwarten"]
  }
}
```

## Nächste Schritte

Wähle das Plugin für deinen Stack und folge seinem Setup-Leitfaden:

- [ESLint](./eslint)
- [RuboCop](./rubocop)
- [PHP_CodeSniffer](./phpcs)
