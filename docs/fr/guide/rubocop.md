# RuboCop (Ruby)

`rubocop-aaa` est un cop RuboCop personnalisé qui impose le motif Arrange-Act-Assert dans le code de test Ruby.

## Installation

```ruby
# Gemfile
group :development, :test do
  gem 'rubocop-aaa', require: false
end
```

```bash
bundle install
```

## Activer le cop

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

## Cop : `AAA/Pattern`

### Configuration

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

### Exemples

#### Given / When / Then

```yaml
AAA/Pattern:
  Labels:
    arrange: [given]
    act:     [when]
    assert:  [then]
```

#### Français

```yaml
AAA/Pattern:
  Labels:
    arrange: [préparation, préparer]
    act:     [exécuter]
    assert:  [vérifier, assertion]
```

### Ce qui est détecté

```ruby
# Offense : "arrange" manquant
it 'bad' do
  # act
  x = do_thing
  # assert
  expect(x).to eq(1)
end

# Offense : ordre incorrect
it 'also bad' do
  # act
  x = do_thing
  # arrange
  y = 1
  # assert
  expect(x).to eq(y)
end
```
