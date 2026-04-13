# ESLint (JS / TS)

`eslint-plugin-aaa-pattern` erzwingt das Arrange-Act-Assert-Muster in JavaScript- / TypeScript-Testdateien.

## Installation

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

Oder die mitgelieferte Empfehlung nutzen:

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

## Regel: `aaa/pattern`

### Optionen

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

| Option | Standard | Beschreibung |
|---|---|---|
| `labels` | Englische Standards | Akzeptierte Kommentartexte je Sektion. Array, Synonyme möglich. |
| `testFunctions` | `["it", "test"]` | Test-definierende Aufrufe, die inspiziert werden. Ergänze `"specify"`, `"example"` etc. |
| `caseSensitive` | `false` | Bei `false` entspricht `// ARRANGE` dem Wort `arrange`. |
| `allowEmptySection` | `true` | Bei `false` wird gemeldet, wenn eine Sektion keine Anweisungen enthält. |

### Beispiele

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

#### Deutsch

```jsonc
{
  "labels": {
    "arrange": ["vorbereiten", "gegeben"],
    "act":     ["ausführen"],
    "assert":  ["prüfen", "erwarten"]
  }
}
```

### Was erkannt wird

```js
// Fehler: "arrange"-Kommentar fehlt
it('bad', () => {
  // act
  const x = doThing()
  // assert
  expect(x).toBe(1)
})

// Fehler: falsche Reihenfolge
it('also bad', () => {
  // act
  const x = doThing()
  // arrange
  const y = 1
  // assert
  expect(x).toBe(y)
})
```

## Auto-Fix

Wenn **alle drei** Sektions-Kommentare fehlen, fügt `eslint --fix` eine `// arrange` / `// act` / `// assert`-Vorlage am Anfang des Testblocks ein. Verschiebe danach jeden Kommentar über den Code, zu dem er gehört.

Andere Fälle (einer oder zwei fehlend, falsche Reihenfolge, leere Sektion) werden nicht automatisch korrigiert — die richtige Einfügeposition hängt von der Absicht des Tests ab, und die Fehlermeldung sagt dir genau, „was" und „wo" einzufügen ist.
