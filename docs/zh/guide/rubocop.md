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
