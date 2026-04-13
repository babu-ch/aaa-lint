# ESLint (JS / TS)

`eslint-plugin-aaa-pattern` aplica o padrão Arrange-Act-Assert em arquivos de teste JavaScript / TypeScript.

## Instalação

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

Ou use a config recomendada embutida:

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

## Regra: `aaa/pattern`

### Opções

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

| Opção | Padrão | Descrição |
|---|---|---|
| `labels` | Padrões em inglês | Textos de comentário aceitos por seção. É um array, então admite sinônimos. |
| `testFunctions` | `["it", "test"]` | Chamadas que definem testes a inspecionar. Adicione `"specify"`, `"example"` etc. se necessário. |
| `caseSensitive` | `false` | Com `false`, `// ARRANGE` equivale a `arrange`. |
| `allowEmptySection` | `true` | Com `false`, reporta quando uma seção fica sem instruções. |

### Exemplos

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

#### Português

```jsonc
{
  "labels": {
    "arrange": ["preparar", "preparação"],
    "act":     ["executar"],
    "assert":  ["verificar", "conferir"]
  }
}
```

### O que detecta

```js
// Erro: comentário "arrange" ausente
it('bad', () => {
  // act
  const x = doThing()
  // assert
  expect(x).toBe(1)
})

// Erro: ordem incorreta
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

Quando os três comentários de seção estão **todos ausentes**, `eslint --fix` insere um template `// arrange` / `// act` / `// assert` no topo do bloco de teste. Depois basta mover cada comentário acima do código a que pertence.

Outros casos (um ou dois ausentes, ordem incorreta, seção vazia) não são corrigidos automaticamente — a posição correta depende da intenção do teste, e a mensagem de erro diz exatamente «o quê» adicionar e «onde».
