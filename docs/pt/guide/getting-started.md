# Primeiros passos

`aaa-lint` é uma família de plugins de lint que aplica o padrão **Arrange-Act-Assert** no seu código de testes. Cada bloco de teste deve conter três comentários marcadores — `arrange`, `act`, `assert` — exatamente nessa ordem.

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

## Por que AAA?

Testes que seguem o padrão AAA são mais fáceis de ler e de modificar. Os revisores localizam preparação, ação testada e expectativas num piscar de olhos. O padrão também incentiva autores a manterem testes pequenos e focados.

`aaa-lint` transforma essa convenção em verificação mecânica, de modo que ela sobreviva ao cansaço das revisões e à rotatividade do time.

## Linguagens suportadas

| Linguagem | Linter | Pacote |
|---|---|---|
| JavaScript / TypeScript | [ESLint](https://eslint.org/) | [`eslint-plugin-aaa-pattern`](./eslint) |
| Ruby | [RuboCop](https://rubocop.org/) | [`rubocop-aaa`](./rubocop) |
| PHP | [PHP_CodeSniffer](https://github.com/PHPCSStandards/PHP_CodeSniffer) | [`phpcs-aaa`](./phpcs) |

As três implementações compartilham as mesmas opções (`labels`, `testFunctions`, `caseSensitive`, `allowEmptySection`), então projetos multilíngues conseguem manter a configuração consistente.

## Personalizar rótulos

Os rótulos padrão são em inglês — `arrange`, `act`, `assert`. Você pode sobrescrevê-los para qualquer idioma ou estilo:

```jsonc
{
  "labels": {
    "arrange": ["given"],
    "act":     ["when"],
    "assert":  ["then"]
  }
}
```

Várias grafias por seção são aceitas, útil quando a equipe varia um pouco nas palavras:

```jsonc
{
  "labels": {
    "arrange": ["preparar", "preparação"],
    "act":     ["executar"],
    "assert":  ["verificar", "conferir"]
  }
}
```

## Próximos passos

Escolha o plugin adequado à sua stack e siga o guia de configuração:

- [ESLint](./eslint)
- [RuboCop](./rubocop)
- [PHP_CodeSniffer](./phpcs)
