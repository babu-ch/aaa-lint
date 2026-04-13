# Démarrage

`aaa-lint` est une famille de plugins de lint qui imposent le motif **Arrange-Act-Assert** dans votre code de test. Chaque bloc de test doit contenir trois commentaires marqueurs — `arrange`, `act`, `assert` — dans cet ordre précis.

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

## Pourquoi AAA ?

Les tests qui suivent le motif AAA sont plus faciles à lire et à modifier. Les relecteurs repèrent la préparation, l'action testée et les attentes d'un coup d'œil. Le motif incite aussi les auteurs à garder des tests courts et focalisés.

`aaa-lint` traduit cette convention en vérification mécanique pour qu'elle résiste à la fatigue des revues et au renouvellement de l'équipe.

## Langages pris en charge

| Langage | Linter | Paquet |
|---|---|---|
| JavaScript / TypeScript | [ESLint](https://eslint.org/) | [`eslint-plugin-aaa`](./eslint) |
| Ruby | [RuboCop](https://rubocop.org/) | [`rubocop-aaa`](./rubocop) |
| PHP | [PHP_CodeSniffer](https://github.com/PHPCSStandards/PHP_CodeSniffer) | [`phpcs-aaa`](./phpcs) |

Les trois implémentations partagent les mêmes options (`labels`, `testFunctions`, `caseSensitive`, `allowEmptySection`), ce qui permet aux projets multilangages de conserver une configuration cohérente.

## Personnaliser les étiquettes

Les étiquettes par défaut sont en anglais : `arrange`, `act`, `assert`. Vous pouvez les remplacer pour n'importe quelle langue ou style :

```jsonc
{
  "labels": {
    "arrange": ["given"],
    "act":     ["when"],
    "assert":  ["then"]
  }
}
```

Plusieurs graphies par section sont acceptées, pratique quand l'équipe varie légèrement dans les formulations :

```jsonc
{
  "labels": {
    "arrange": ["préparation", "préparer"],
    "act":     ["exécuter"],
    "assert":  ["vérifier", "assertion"]
  }
}
```

## Étapes suivantes

Choisissez le plugin adapté à votre stack et suivez son guide de configuration :

- [ESLint](./eslint)
- [RuboCop](./rubocop)
- [PHP_CodeSniffer](./phpcs)
