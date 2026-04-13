# phpcs-aaa

PHP_CodeSniffer standard that enforces the **Arrange-Act-Assert** pattern in PHP test methods.

## Install

```bash
composer require --dev babu-ch/phpcs-aaa
```

If you are not using the [phpcodesniffer-composer-installer](https://github.com/PHPCSStandards/composer-installer), point PHPCS at the standard manually:

```bash
vendor/bin/phpcs --config-set installed_paths vendor/babu-ch/phpcs-aaa
```

## Usage

Add to your `phpcs.xml.dist`:

```xml
<?xml version="1.0"?>
<ruleset name="Project">
    <file>tests</file>
    <rule ref="AAA"/>
</ruleset>
```

Or run directly:

```bash
vendor/bin/phpcs --standard=AAA tests/
```

## What it checks

Every test method (name starting with `test` by default, per PHPUnit convention) must contain three marker comments in order:

```php
public function testAdds(): void
{
    // arrange
    $a = 1;
    $b = 2;

    // act
    $sum = $a + $b;

    // assert
    $this->assertSame(3, $sum);
}
```

## Configuration

Override properties in your ruleset:

```xml
<rule ref="AAA.Tests.Pattern">
    <properties>
        <property name="caseSensitive" value="false"/>
        <property name="allowEmptySection" value="true"/>
        <property name="testFunctionPrefixes" type="array">
            <element value="test"/>
            <element value="it"/>
        </property>
        <property name="labels" type="array">
            <element key="arrange" value="arrange"/>
            <element key="act"     value="act"/>
            <element key="assert"  value="assert"/>
        </property>
    </properties>
</rule>
```

Note: the `labels` property via XML only accepts scalar values per key. For multiple synonyms (e.g. Japanese `準備 / 前準備`), configure via a custom sniff subclass or a PHP-based ruleset at the moment.

### Given / When / Then

```xml
<property name="labels" type="array">
    <element key="arrange" value="given"/>
    <element key="act"     value="when"/>
    <element key="assert"  value="then"/>
</property>
```

## Development

```bash
composer install
composer test
```

Tests use PHPUnit against the PHPCS Ruleset/DummyFile API directly (no fixture file dance).

## License

MIT
