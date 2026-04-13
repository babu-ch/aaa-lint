# RuboCop (Ruby)

`rubocop-aaa` é um cop personalizado do RuboCop que aplica o padrão Arrange-Act-Assert em código de testes Ruby.

## Instalação

```ruby
# Gemfile
group :development, :test do
  gem 'rubocop-aaa', require: false
end
```

```bash
bundle install
```

## Ativar o cop

```yaml
# .rubocop.yml
require:
  - rubocop-aaa

AAA/Pattern:
  Enabled: true
  Include:
    - 'spec/**/*.rb'
    - 'test/**/*.rb'
```

## Cop: `AAA/Pattern`

### Configuração

```yaml
AAA/Pattern:
  TestFunctions:
    - it
    - test
    - specify
    - example
  Labels:
    arrange: [arrange]
    act:     [act]
    assert:  [assert]
  CaseSensitive: false
  AllowEmptySection: true
```

### Exemplos

#### Given / When / Then

```yaml
AAA/Pattern:
  Labels:
    arrange: [given]
    act:     [when]
    assert:  [then]
```

#### Português

```yaml
AAA/Pattern:
  Labels:
    arrange: [preparar, preparação]
    act:     [executar]
    assert:  [verificar, conferir]
```

### O que detecta

```ruby
# Offense: "arrange" ausente
it 'bad' do
  # act
  x = do_thing
  # assert
  expect(x).to eq(1)
end

# Offense: ordem incorreta
it 'also bad' do
  # act
  x = do_thing
  # arrange
  y = 1
  # assert
  expect(x).to eq(y)
end
```

## Auto-correção

Quando os três comentários de seção estão **todos ausentes**, `rubocop -a` (ou `--autocorrect`) insere um template `# arrange` / `# act` / `# assert` no topo do bloco. Depois basta mover cada comentário acima do código a que pertence.

Outros casos (um ou dois ausentes, ordem incorreta, seção vazia) não são auto-corrigidos — a posição correta depende da intenção do teste, e a mensagem de offense diz exatamente «o quê» adicionar e «onde».
