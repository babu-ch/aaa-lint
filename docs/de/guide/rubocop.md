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

## Auto-Korrektur

Wenn **alle drei** Sektions-Kommentare fehlen, fügt `rubocop -a` (oder `--autocorrect`) eine `# arrange` / `# act` / `# assert`-Vorlage am Anfang des Blocks ein. Verschiebe danach jeden Kommentar über den Code, zu dem er gehört.

Andere Fälle (einer oder zwei fehlend, falsche Reihenfolge, leere Sektion) werden nicht automatisch korrigiert — die richtige Einfügeposition hängt von der Absicht des Tests ab, und die Offense-Meldung sagt dir genau, „was" und „wo" einzufügen ist.
