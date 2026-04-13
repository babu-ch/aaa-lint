# PHP_CodeSniffer (PHP)

`phpcs-aaa` é um padrão PHPCS que aplica o padrão Arrange-Act-Assert em métodos de teste PHP.

## Instalação

```bash
composer require --dev babu-ch/phpcs-aaa
```

Se você não usa o [phpcodesniffer-composer-installer](https://github.com/PHPCSStandards/composer-installer), registre o caminho do standard manualmente:

```bash
vendor/bin/phpcs --config-set installed_paths vendor/babu-ch/phpcs-aaa
```

## Ativar o sniff

```xml
<!-- phpcs.xml.dist -->
<?xml version="1.0"?>
<ruleset name="Project">
    <file>tests</file>
    <rule ref="AAA"/>
</ruleset>
```

Execução ad-hoc:

```bash
vendor/bin/phpcs --standard=AAA tests/
```

## Sniff: `AAA.Tests.Pattern`

### Configuração

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

Métodos de teste são detectados por prefixo do nome (convenção PHPUnit: métodos começando com `test`). Estenda a lista se usar outra nomenclatura.

### Exemplos

#### Given / When / Then

```xml
<property name="labels" type="array">
    <element key="arrange" value="given"/>
    <element key="act"     value="when"/>
    <element key="assert"  value="then"/>
</property>
```

### O que detecta

```php
// Erro: "arrange" ausente
public function testBad(): void
{
    // act
    $x = $this->doThing();
    // assert
    $this->assertSame(1, $x);
}

// Erro: ordem incorreta
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
