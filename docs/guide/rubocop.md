# RuboCop (Ruby)

`rubocop-aaa` is a custom RuboCop cop that enforces the Arrange-Act-Assert pattern in Ruby test code.

## Install

```ruby
# Gemfile
group :development, :test do
  gem 'rubocop-aaa', require: false
end
```

```bash
bundle install
```

## Enable the cop

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

### Examples

#### Given / When / Then

```yaml
AAA/Pattern:
  Labels:
    arrange: [given]
    act:     [when]
    assert:  [then]
```

#### Japanese

```yaml
AAA/Pattern:
  Labels:
    arrange: [準備, 前準備]
    act:     [実行]
    assert:  [検証, 確認]
```

### What it catches

```ruby
# Offense: missing "arrange"
it 'bad' do
  # act
  x = do_thing
  # assert
  expect(x).to eq(1)
end

# Offense: wrong order
it 'also bad' do
  # act
  x = do_thing
  # arrange
  y = 1
  # assert
  expect(x).to eq(y)
end
```

## Auto-correct

When **all three** section comments are missing, `rubocop -a` (or `--autocorrect`) inserts a `# arrange` / `# act` / `# assert` template at the top of the block. You then move each comment above the code that belongs to it.

Other cases (one or two missing, wrong order, empty section) are not auto-corrected because the correct insertion point depends on the test's intent — the offense message tells you exactly what to add and where.
