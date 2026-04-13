# PHP_CodeSniffer (PHP)

`phpcs-aaa` es un estándar PHPCS que impone el patrón Arrange-Act-Assert en métodos de test PHP.

## Instalación

```bash
composer require --dev babu-ch/phpcs-aaa
```

Si no usas [phpcodesniffer-composer-installer](https://github.com/PHPCSStandards/composer-installer), registra la ruta del estándar manualmente:

```bash
vendor/bin/phpcs --config-set installed_paths vendor/babu-ch/phpcs-aaa
```

## Habilitar el sniff

```xml
<!-- phpcs.xml.dist -->
<?xml version="1.0"?>
<ruleset name="Project">
    <file>tests</file>
    <rule ref="AAA"/>
</ruleset>
```

Ejecución ad-hoc:

```bash
vendor/bin/phpcs --standard=AAA tests/
```

## Sniff: `AAA.Tests.Pattern`

### Configuración

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

Los métodos de test se detectan por prefijo de nombre (convención PHPUnit: métodos que empiezan por `test`). Extiende la lista si usas otra nomenclatura.

### Ejemplos

#### Given / When / Then

```xml
<property name="labels" type="array">
    <element key="arrange" value="given"/>
    <element key="act"     value="when"/>
    <element key="assert"  value="then"/>
</property>
```

### Qué detecta

```php
// Error: falta "arrange"
public function testBad(): void
{
    // act
    $x = $this->doThing();
    // assert
    $this->assertSame(1, $x);
}

// Error: orden incorrecto
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

Cuando los tres comentarios de sección están **todos ausentes**, `vendor/bin/phpcbf` (el auto-fixer incluido con PHP_CodeSniffer) inserta una plantilla `// arrange` / `// act` / `// assert` al inicio del método de test. Luego solo tienes que mover cada comentario sobre el código que le corresponde.

Otros casos (uno o dos ausentes, orden incorrecto, sección vacía) no se corrigen automáticamente — la posición correcta depende de la intención del test, y el mensaje de error te dice exactamente «qué» añadir y «dónde».
