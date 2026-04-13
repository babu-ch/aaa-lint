# ESLint (JS / TS)

`eslint-plugin-aaa` impone el patrón Arrange-Act-Assert en archivos de test de JavaScript / TypeScript.

## Instalación

```bash
npm install --save-dev eslint-plugin-aaa
```

## Flat config (ESLint v9+)

```js
// eslint.config.js
import aaa from 'eslint-plugin-aaa'

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

O usa la config recomendada incluida:

```js
import aaa from 'eslint-plugin-aaa'

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

## Regla: `aaa/pattern`

### Opciones

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

| Opción | Por defecto | Descripción |
|---|---|---|
| `labels` | Inglés por defecto | Textos de comentario aceptados por sección. Es un array, así que admite sinónimos. |
| `testFunctions` | `["it", "test"]` | Llamadas que definen tests a inspeccionar. Añade `"specify"`, `"example"` etc. si hace falta. |
| `caseSensitive` | `false` | Si es `false`, `// ARRANGE` equivale a `arrange`. |
| `allowEmptySection` | `true` | Si es `false`, reporta cuando una sección no tiene sentencias. |

### Ejemplos

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

#### Español

```jsonc
{
  "labels": {
    "arrange": ["preparar", "preparación"],
    "act":     ["ejecutar"],
    "assert":  ["verificar", "comprobar"]
  }
}
```

### Qué detecta

```js
// Error: falta el comentario "arrange"
it('bad', () => {
  // act
  const x = doThing()
  // assert
  expect(x).toBe(1)
})

// Error: orden incorrecto
it('also bad', () => {
  // act
  const x = doThing()
  // arrange
  const y = 1
  // assert
  expect(x).toBe(y)
})
```
