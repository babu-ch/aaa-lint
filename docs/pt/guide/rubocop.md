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
