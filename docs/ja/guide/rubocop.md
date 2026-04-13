# RuboCop (Ruby)

`rubocop-aaa` は、Ruby のテストコードに対して Arrange-Act-Assert パターンを強制するカスタム Cop です。

## インストール

```ruby
# Gemfile
group :development, :test do
  gem 'rubocop-aaa', require: false
end
```

```bash
bundle install
```

## Cop を有効化

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

### 設定

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

### 例

#### Given / When / Then

```yaml
AAA/Pattern:
  Labels:
    arrange: [given]
    act:     [when]
    assert:  [then]
```

#### 日本語

```yaml
AAA/Pattern:
  Labels:
    arrange: [準備, 前準備]
    act:     [実行]
    assert:  [検証, 確認]
```

### 検出例

```ruby
# エラー: "arrange" が無い
it 'bad' do
  # act
  x = do_thing
  # assert
  expect(x).to eq(1)
end

# エラー: 順序が逆
it 'also bad' do
  # act
  x = do_thing
  # arrange
  y = 1
  # assert
  expect(x).to eq(y)
end
```

## 自動修正 (auto-correct)

3つすべてのセクションコメントが欠けている場合、`rubocop -a` (または `--autocorrect`) がブロックの先頭に `# arrange` / `# act` / `# assert` のテンプレートを挿入します。あとは各コメントを該当するコードの上に移動するだけです。

それ以外のケース (1〜2個欠けている、順序が違う、空セクション) は自動修正されません — 適切な挿入位置はテストの意図に依存するため、オフェンスメッセージが「何を」「どこに」追加すべきかを具体的に教えてくれます。
