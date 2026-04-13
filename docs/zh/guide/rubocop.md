# RuboCop (Ruby)

`rubocop-aaa` 是一个自定义 RuboCop cop,在 Ruby 测试代码中强制执行 Arrange-Act-Assert 模式。

## 安装

```ruby
# Gemfile
group :development, :test do
  gem 'rubocop-aaa', require: false
end
```

```bash
bundle install
```

## 启用 cop

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

### 配置

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

### 示例

#### Given / When / Then

```yaml
AAA/Pattern:
  Labels:
    arrange: [given]
    act:     [when]
    assert:  [then]
```

#### 中文

```yaml
AAA/Pattern:
  Labels:
    arrange: [准备, 前期准备]
    act:     [执行]
    assert:  [验证, 断言]
```

### 检测示例

```ruby
# 错误: 缺少 "arrange"
it 'bad' do
  # act
  x = do_thing
  # assert
  expect(x).to eq(1)
end

# 错误: 顺序错误
it 'also bad' do
  # act
  x = do_thing
  # arrange
  y = 1
  # assert
  expect(x).to eq(y)
end
```

## 自动修复

当三个段落注释**全部缺失**时,`rubocop -a` (或 `--autocorrect`) 会在块顶部插入 `# arrange` / `# act` / `# assert` 模板。然后只需将各注释移到对应代码的上方即可。

其他情况 (缺失一两个、顺序错误、空段) 不会自动修复 — 因为正确的插入位置取决于测试的意图,违规信息会明确告诉你「该添加什么」「该放在哪里」。
