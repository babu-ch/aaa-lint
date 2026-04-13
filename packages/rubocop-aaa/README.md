# rubocop-aaa

RuboCop cop that enforces the **Arrange-Act-Assert** pattern in Ruby test code.

## Install

```ruby
# Gemfile
group :development, :test do
  gem 'rubocop-aaa', require: false
end
```

## Usage

Enable the cop in your `.rubocop.yml`:

```yaml
require:
  - rubocop-aaa

AAA/Pattern:
  Enabled: true
  Include:
    - 'spec/**/*.rb'
    - 'test/**/*.rb'
```

## What it checks

Every test block (`it`, `test`, `specify`, `example` by default) must contain three marker comments in order:

```ruby
it 'adds' do
  # arrange
  a = 1
  b = 2

  # act
  sum = a + b

  # assert
  expect(sum).to eq(3)
end
```

## Configuration

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

### Given / When / Then

```yaml
AAA/Pattern:
  Labels:
    arrange: [given]
    act:     [when]
    assert:  [then]
```

### Japanese

Japanese phrasing varies, so no preset ships — configure with the wording your team uses:

```yaml
AAA/Pattern:
  Labels:
    arrange: [準備, 前準備]
    act:     [実行]
    assert:  [検証, 確認]
```

## Auto-correct

When **all three** section comments are missing, `rubocop -a` (or `rubocop --autocorrect`) inserts a `# arrange` / `# act` / `# assert` template at the top of the block. You then move each comment above the code that belongs to it.

Other cases — one or two sections missing, wrong order, empty section — are reported with explicit hints in the offense message but are not auto-corrected, because the correct insertion point depends on the test's intent.

## License

MIT
