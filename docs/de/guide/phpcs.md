# PHP_CodeSniffer (PHP)

`phpcs-aaa` ist ein PHPCS-Standard, der das Arrange-Act-Assert-Muster in PHP-Testmethoden erzwingt.

## Installation

```bash
composer require --dev babu-ch/phpcs-aaa
```

Wenn du [phpcodesniffer-composer-installer](https://github.com/PHPCSStandards/composer-installer) nicht verwendest, registriere den Standardpfad manuell:

```bash
vendor/bin/phpcs --config-set installed_paths vendor/babu-ch/phpcs-aaa
```

## Sniff aktivieren

```xml
<!-- phpcs.xml.dist -->
<?xml version="1.0"?>
<ruleset name="Project">
    <file>tests</file>
    <rule ref="AAA"/>
</ruleset>
```

Ad-hoc-Ausführung:

```bash
vendor/bin/phpcs --standard=AAA tests/
```

## Sniff: `AAA.Tests.Pattern`

### Konfiguration

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

Testmethoden werden über den Namenspräfix erkannt (PHPUnit-Konvention: Methoden, die mit `test` beginnen). Erweitere die Liste bei abweichender Benennung.

### Beispiele

#### Given / When / Then

```xml
<property name="labels" type="array">
    <element key="arrange" value="given"/>
    <element key="act"     value="when"/>
    <element key="assert"  value="then"/>
</property>
```

### Was erkannt wird

```php
// Fehler: "arrange" fehlt
public function testBad(): void
{
    // act
    $x = $this->doThing();
    // assert
    $this->assertSame(1, $x);
}

// Fehler: falsche Reihenfolge
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

## Auto-Fix

Wenn **alle drei** Sektions-Kommentare fehlen, fügt `vendor/bin/phpcbf` (der mit PHP_CodeSniffer mitgelieferte Auto-Fixer) eine `// arrange` / `// act` / `// assert`-Vorlage am Anfang der Testmethode ein. Verschiebe danach jeden Kommentar über den Code, zu dem er gehört.

Andere Fälle (einer oder zwei fehlend, falsche Reihenfolge, leere Sektion) werden nicht automatisch korrigiert — die richtige Einfügeposition hängt von der Absicht des Tests ab, und die Fehlermeldung sagt dir genau, „was" und „wo" einzufügen ist.
