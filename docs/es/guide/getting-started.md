# Primeros pasos

`aaa-lint` es una familia de plugins de lint que imponen el patrón **Arrange-Act-Assert** en tu código de tests. Cada bloque de test debe contener tres comentarios marcadores — `arrange`, `act`, `assert` — en ese orden exacto.

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

## ¿Por qué AAA?

Los tests que siguen el patrón AAA son más fáciles de leer y de modificar. Los revisores pueden localizar la preparación, la acción bajo prueba y las expectativas de un vistazo. El patrón también incentiva a los autores a mantener los tests pequeños y enfocados.

`aaa-lint` convierte esta convención en una verificación mecánica, de modo que sobreviva al cansancio de las revisiones y al reemplazo de miembros del equipo.

## Lenguajes soportados

| Lenguaje | Linter | Paquete |
|---|---|---|
| JavaScript / TypeScript | [ESLint](https://eslint.org/) | [`eslint-plugin-aaa-pattern`](./eslint) |
| Ruby | [RuboCop](https://rubocop.org/) | [`rubocop-aaa`](./rubocop) |
| PHP | [PHP_CodeSniffer](https://github.com/PHPCSStandards/PHP_CodeSniffer) | [`phpcs-aaa`](./phpcs) |

Las tres implementaciones comparten el mismo conjunto de opciones (`labels`, `testFunctions`, `caseSensitive`, `allowEmptySection`), así que los proyectos multilenguaje pueden mantener una configuración consistente.

## Personalizar las etiquetas

Las etiquetas por defecto están en inglés: `arrange`, `act`, `assert`. Puedes sobreescribirlas para cualquier idioma o estilo:

```jsonc
{
  "labels": {
    "arrange": ["given"],
    "act":     ["when"],
    "assert":  ["then"]
  }
}
```

Se aceptan varias ortografías por sección, útil cuando los miembros del equipo escriben un poco distinto:

```jsonc
{
  "labels": {
    "arrange": ["preparar", "preparación"],
    "act":     ["ejecutar"],
    "assert":  ["verificar", "comprobar"]
  }
}
```

## Siguientes pasos

Elige el plugin para tu stack y sigue su guía de configuración:

- [ESLint](./eslint)
- [RuboCop](./rubocop)
- [PHP_CodeSniffer](./phpcs)
