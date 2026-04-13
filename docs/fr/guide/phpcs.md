# PHP_CodeSniffer (PHP)

`phpcs-aaa` est un standard PHPCS qui impose le motif Arrange-Act-Assert dans les méthodes de test PHP.

## Installation

```bash
composer require --dev babu-ch/phpcs-aaa
```

Si vous n'utilisez pas [phpcodesniffer-composer-installer](https://github.com/PHPCSStandards/composer-installer), enregistrez manuellement le chemin du standard :

```bash
vendor/bin/phpcs --config-set installed_paths vendor/babu-ch/phpcs-aaa
```

## Activer le sniff

```xml
<!-- phpcs.xml.dist -->
<?xml version="1.0"?>
<ruleset name="Project">
    <file>tests</file>
    <rule ref="AAA"/>
</ruleset>
```

Exécution ponctuelle :

```bash
vendor/bin/phpcs --standard=AAA tests/
```

## Sniff : `AAA.Tests.Pattern`

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

Les méthodes de test sont détectées par préfixe de nom (convention PHPUnit : méthodes commençant par `test`). Étendez la liste si vous utilisez une autre nomenclature.

### Exemples

#### Given / When / Then

```xml
<property name="labels" type="array">
    <element key="arrange" value="given"/>
    <element key="act"     value="when"/>
    <element key="assert"  value="then"/>
</property>
```

### Ce qui est détecté

```php
// Erreur : "arrange" manquant
public function testBad(): void
{
    // act
    $x = $this->doThing();
    // assert
    $this->assertSame(1, $x);
}

// Erreur : ordre incorrect
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

Quand les trois commentaires de section manquent **tous**, `vendor/bin/phpcbf` (l'auto-fixer livré avec PHP_CodeSniffer) insère un modèle `// arrange` / `// act` / `// assert` en haut de la méthode de test. Il ne reste plus qu'à déplacer chaque commentaire au-dessus du code qui lui correspond.

Les autres cas (un ou deux manquants, ordre incorrect, section vide) ne sont pas corrigés automatiquement — l'emplacement correct dépend de l'intention du test, et le message d'erreur indique précisément « quoi » ajouter et « où ».
