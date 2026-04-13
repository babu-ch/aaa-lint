# RuboCop (Ruby)

`rubocop-aaa`는 Ruby 테스트 코드에 Arrange-Act-Assert 패턴을 강제하는 커스텀 RuboCop cop입니다.

## 설치

```ruby
# Gemfile
group :development, :test do
  gem 'rubocop-aaa', require: false
end
```

```bash
bundle install
```

## Cop 활성화

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

### 설정

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

### 예시

#### Given / When / Then

```yaml
AAA/Pattern:
  Labels:
    arrange: [given]
    act:     [when]
    assert:  [then]
```

#### 한국어

```yaml
AAA/Pattern:
  Labels:
    arrange: [준비, 사전준비]
    act:     [실행]
    assert:  [검증, 확인]
```

### 감지 예시

```ruby
# 오류: "arrange" 누락
it 'bad' do
  # act
  x = do_thing
  # assert
  expect(x).to eq(1)
end

# 오류: 순서가 잘못됨
it 'also bad' do
  # act
  x = do_thing
  # arrange
  y = 1
  # assert
  expect(x).to eq(y)
end
```
