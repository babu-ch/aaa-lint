# RuboCop (Ruby)

`rubocop-aaa` ist ein eigener RuboCop-Cop, der das Arrange-Act-Assert-Muster in Ruby-Testcode erzwingt.

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

## Cop aktivieren

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

### Konfiguration

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

### Beispiele

#### Given / When / Then

```yaml
AAA/Pattern:
  Labels:
    arrange: [given]
    act:     [when]
    assert:  [then]
```

#### Deutsch

```yaml
AAA/Pattern:
  Labels:
    arrange: [vorbereiten, gegeben]
    act:     [ausführen]
    assert:  [prüfen, erwarten]
```

### Was erkannt wird

```ruby
# Offense: "arrange" fehlt
it 'bad' do
  # act
  x = do_thing
  # assert
  expect(x).to eq(1)
end

# Offense: falsche Reihenfolge
it 'also bad' do
  # act
  x = do_thing
  # arrange
  y = 1
  # assert
  expect(x).to eq(y)
end
```
