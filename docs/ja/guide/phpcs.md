# PHP_CodeSniffer (PHP)

`phpcs-aaa` は、PHP のテストメソッドに対して Arrange-Act-Assert パターンを強制する PHPCS 標準です。

## インストール

```bash
composer require --dev babu-ch/phpcs-aaa
```

[phpcodesniffer-composer-installer](https://github.com/PHPCSStandards/composer-installer) を使っていない場合は、標準パスを手動で登録してください。

```bash
vendor/bin/phpcs --config-set installed_paths vendor/babu-ch/phpcs-aaa
```

## Sniff を有効化

```xml
<!-- phpcs.xml.dist -->
<?xml version="1.0"?>
<ruleset name="Project">
    <file>tests</file>
    <rule ref="AAA"/>
</ruleset>
```

アドホック実行:

```bash
vendor/bin/phpcs --standard=AAA tests/
```

## Sniff: `AAA.Tests.Pattern`

### 設定

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

テストメソッドはメソッド名の接頭辞でマッチします (PHPUnit 慣習により `test` で始まるメソッド)。異なる命名を使っている場合はリストを拡張してください。

### 例

#### Given / When / Then

```xml
<property name="labels" type="array">
    <element key="arrange" value="given"/>
    <element key="act"     value="when"/>
    <element key="assert"  value="then"/>
</property>
```

### 検出例

```php
// エラー: "arrange" が無い
public function testBad(): void
{
    // act
    $x = $this->doThing();
    // assert
    $this->assertSame(1, $x);
}

// エラー: 順序が逆
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

## 自動修正 (auto-fix)

3つすべてのセクションコメントが欠けている場合、`vendor/bin/phpcbf` (PHP_CodeSniffer 同梱の自動修正ツール) がテストメソッドの先頭に `// arrange` / `// act` / `// assert` のテンプレートを挿入します。あとは各コメントを該当するコードの上に移動するだけです。

それ以外のケース (1〜2個欠けている、順序が違う、空セクション) は自動修正されません — 適切な挿入位置はテストの意図に依存するため、エラーメッセージが「何を」「どこに」追加すべきかを具体的に教えてくれます。
