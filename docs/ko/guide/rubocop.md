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

## 자동 수정

세 개의 섹션 주석이 **모두 누락**된 경우, `rubocop -a` (또는 `--autocorrect`) 가 블록 상단에 `# arrange` / `# act` / `# assert` 템플릿을 삽입합니다. 이후 각 주석을 해당 코드 위로 옮기기만 하면 됩니다.

다른 경우 (한두 개 누락, 순서 오류, 빈 섹션) 는 자동 수정되지 않습니다 — 올바른 삽입 위치가 테스트 의도에 따라 다르기 때문이며, 위반 메시지가 「무엇을」「어디에」 추가해야 하는지 명확히 알려줍니다.
