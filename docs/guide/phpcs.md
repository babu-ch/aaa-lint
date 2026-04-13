# PHP_CodeSniffer (PHP)

`phpcs-aaa` is a PHPCS standard that enforces the Arrange-Act-Assert pattern in PHP test methods.

## Install

```bash
composer require --dev babu-ch/phpcs-aaa
```

If you do not use [phpcodesniffer-composer-installer](https://github.com/PHPCSStandards/composer-installer), register the standard path manually:

```bash
vendor/bin/phpcs --config-set installed_paths vendor/babu-ch/phpcs-aaa
```

## Enable the sniff

```xml
<!-- phpcs.xml.dist -->
<?xml version="1.0"?>
<ruleset name="Project">
    <file>tests</file>
    <rule ref="AAA"/>
</ruleset>
```

Or run ad-hoc:

```bash
vendor/bin/phpcs --standard=AAA tests/
```

## Sniff: `AAA.Tests.Pattern`

### Configuration

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

Test methods are matched by name prefix (PHPUnit convention: methods starting with `test`). Extend the list if your suite uses different naming.

### Examples

#### Given / When / Then

```xml
<property name="labels" type="array">
    <element key="arrange" value="given"/>
    <element key="act"     value="when"/>
    <element key="assert"  value="then"/>
</property>
```

### What it catches

```php
// Error: missing "arrange"
public function testBad(): void
{
    // act
    $x = $this->doThing();
    // assert
    $this->assertSame(1, $x);
}

// Error: wrong order
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

## Auto-fix

When **all three** section comments are missing, `vendor/bin/phpcbf` (the auto-fixer that ships with PHP_CodeSniffer) inserts a `// arrange` / `// act` / `// assert` template at the top of the test method. You then move each comment above the code that belongs to it.

Other cases (one or two missing, wrong order, empty section) are not auto-fixed because the correct insertion point depends on the test's intent — the error message tells you exactly what to add and where.
