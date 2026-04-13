# PHP_CodeSniffer (PHP)

`phpcs-aaa`는 PHP 테스트 메서드에 Arrange-Act-Assert 패턴을 강제하는 PHPCS 표준입니다.

## 설치

```bash
composer require --dev babu-ch/phpcs-aaa
```

[phpcodesniffer-composer-installer](https://github.com/PHPCSStandards/composer-installer)를 사용하지 않는다면 표준 경로를 수동으로 등록하세요.

```bash
vendor/bin/phpcs --config-set installed_paths vendor/babu-ch/phpcs-aaa
```

## Sniff 활성화

```xml
<!-- phpcs.xml.dist -->
<?xml version="1.0"?>
<ruleset name="Project">
    <file>tests</file>
    <rule ref="AAA"/>
</ruleset>
```

임시 실행:

```bash
vendor/bin/phpcs --standard=AAA tests/
```

## Sniff: `AAA.Tests.Pattern`

### 설정

```xml
<rule ref="AAA.Tests.Pattern">
    <properties>
        <property name="caseSensitive" value="false"/>
        <property name="allowEmptySection" value="true"/>
        <property name="testFunctionPrefixes" type="array">
            <element value="test"/>
        </property>
        <property name="labels" type="array">
            <element key="arrange" value="arrange"/>
            <element key="act"     value="act"/>
            <element key="assert"  value="assert"/>
        </property>
    </properties>
</rule>
```

테스트 메서드는 이름 접두사로 매칭됩니다 (PHPUnit 관례: `test`로 시작하는 메서드). 다른 네이밍을 쓴다면 목록을 확장하세요.

### 예시

#### Given / When / Then

```xml
<property name="labels" type="array">
    <element key="arrange" value="given"/>
    <element key="act"     value="when"/>
    <element key="assert"  value="then"/>
</property>
```

### 감지 예시

```php
// 오류: "arrange" 누락
public function testBad(): void
{
    // act
    $x = $this->doThing();
    // assert
    $this->assertSame(1, $x);
}

// 오류: 순서가 잘못됨
public function testAlsoBad(): void
{
    // act
    $x = $this->doThing();
    // arrange
    $y = 1;
    // assert
    $this->assertSame($y, $x);
}
```
