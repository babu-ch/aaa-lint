# PHP_CodeSniffer (PHP)

`phpcs-aaa` 是一个 PHPCS 标准,在 PHP 测试方法中强制执行 Arrange-Act-Assert 模式。

## 安装

```bash
composer require --dev babu-ch/phpcs-aaa
```

若未使用 [phpcodesniffer-composer-installer](https://github.com/PHPCSStandards/composer-installer),请手动注册标准路径:

```bash
vendor/bin/phpcs --config-set installed_paths vendor/babu-ch/phpcs-aaa
```

## 启用 sniff

```xml
<!-- phpcs.xml.dist -->
<?xml version="1.0"?>
<ruleset name="Project">
    <file>tests</file>
    <rule ref="AAA"/>
</ruleset>
```

临时执行:

```bash
vendor/bin/phpcs --standard=AAA tests/
```

## Sniff: `AAA.Tests.Pattern`

### 配置

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

按方法名前缀匹配测试方法 (PHPUnit 约定: 以 `test` 开头的方法)。若命名不同请扩展列表。

### 示例

#### Given / When / Then

```xml
<property name="labels" type="array">
    <element key="arrange" value="given"/>
    <element key="act"     value="when"/>
    <element key="assert"  value="then"/>
</property>
```

### 检测示例

```php
// 错误: 缺少 "arrange"
public function testBad(): void
{
    // act
    $x = $this->doThing();
    // assert
    $this->assertSame(1, $x);
}

// 错误: 顺序错误
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

## 自动修复

当三个段落注释**全部缺失**时,`vendor/bin/phpcbf` (PHP_CodeSniffer 自带的自动修复工具) 会在测试方法顶部插入 `// arrange` / `// act` / `// assert` 模板。然后只需将各注释移到对应代码的上方即可。

其他情况 (缺失一两个、顺序错误、空段) 不会自动修复 — 因为正确的插入位置取决于测试的意图,错误信息会明确告诉你「该添加什么」「该放在哪里」。
