# ESLint (JS / TS)

`eslint-plugin-aaa-pattern` impose le motif Arrange-Act-Assert dans les fichiers de test JavaScript / TypeScript.

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

Ou utilisez la config recommandée fournie :

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

## Règle : `aaa/pattern`

### Options

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

| Option | Défaut | Description |
|---|---|---|
| `labels` | Défauts anglais | Texte de commentaire accepté par section. Tableau : plusieurs synonymes possibles. |
| `testFunctions` | `["it", "test"]` | Appels définissant des tests à inspecter. Ajoutez `"specify"`, `"example"` si besoin. |
| `caseSensitive` | `false` | Si `false`, `// ARRANGE` correspond à `arrange`. |
| `allowEmptySection` | `true` | Si `false`, signale une section sans instruction. |

### Exemples

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

#### Français

```jsonc
{
  "labels": {
    "arrange": ["préparation", "préparer"],
    "act":     ["exécuter"],
    "assert":  ["vérifier", "assertion"]
  }
}
```

### Ce qui est détecté

```js
// Erreur : commentaire "arrange" manquant
it('bad', () => {
  // act
  const x = doThing()
  // assert
  expect(x).toBe(1)
})

// Erreur : ordre incorrect
it('also bad', () => {
  // act
  const x = doThing()
  // arrange
  const y = 1
  // assert
  expect(x).toBe(y)
})
```

## Auto-fix

Quand les trois commentaires de section manquent **tous**, `eslint --fix` insère un modèle `// arrange` / `// act` / `// assert` en haut du bloc de test. Il ne reste plus qu'à déplacer chaque commentaire au-dessus du code qui lui correspond.

Les autres cas (un ou deux manquants, ordre incorrect, section vide) ne sont pas corrigés automatiquement — l'emplacement correct dépend de l'intention du test, et le message d'erreur indique précisément « quoi » ajouter et « où ».
