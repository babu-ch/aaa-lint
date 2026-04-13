<?php

namespace AAA\Tests;

use PHP_CodeSniffer\Config;
use PHP_CodeSniffer\Files\DummyFile;
use PHP_CodeSniffer\Ruleset;
use PHPUnit\Framework\TestCase;

final class PatternSniffTest extends TestCase
{
    /**
     * @param array<string,mixed> $sniffProperties
     * @return array<int, array{line:int, message:string, source:string}>
     */
    private function lint(string $code, array $sniffProperties = []): array
    {
        $config = new Config([], false);
        $config->standards = ['AAA'];
        $config->sniffs = ['AAA.Tests.Pattern'];

        $ruleset = new Ruleset($config);

        foreach ($sniffProperties as $name => $value) {
            foreach ($ruleset->sniffs as $sniff) {
                if ($sniff instanceof \AAA\Sniffs\Tests\PatternSniff) {
                    $sniff->{$name} = $value;
                }
            }
        }

        $file = new DummyFile($code, $ruleset, $config);
        $file->process();

        $flat = [];
        foreach ($file->getErrors() as $line => $columns) {
            foreach ($columns as $errors) {
                foreach ($errors as $error) {
                    $flat[] = [
                        'line'    => $line,
                        'message' => $error['message'],
                        'source'  => $error['source'],
                    ];
                }
            }
        }
        return $flat;
    }

    public function testAcceptsCorrectOrder(): void
    {
        $errors = $this->lint(<<<'PHP'
<?php
class SomeTest {
    public function testAdds(): void {
        // arrange
        $a = 1;
        // act
        $b = $a + 1;
        // assert
        $this->assertSame(2, $b);
    }
}
PHP);
        $this->assertSame([], $errors);
    }

    public function testFlagsMissingArrange(): void
    {
        $errors = $this->lint(<<<'PHP'
<?php
class SomeTest {
    public function testMissing(): void {
        // act
        $a = 1;
        // assert
        $this->assertSame(1, $a);
    }
}
PHP);
        $this->assertCount(1, $errors);
        $this->assertStringContainsString('arrange', $errors[0]['message']);
    }

    public function testFlagsWrongOrder(): void
    {
        $errors = $this->lint(<<<'PHP'
<?php
class SomeTest {
    public function testOrder(): void {
        // act
        $b = 1;
        // arrange
        $a = 0;
        // assert
        $this->assertSame(1, $b);
    }
}
PHP);
        $this->assertCount(1, $errors);
        $this->assertStringContainsString('order', strtolower($errors[0]['message']));
    }

    public function testIgnoresNonTestMethods(): void
    {
        $errors = $this->lint(<<<'PHP'
<?php
class Helper {
    public function helperMethod(): void {
        $a = 1;
    }
}
PHP);
        $this->assertSame([], $errors);
    }

    public function testCaseInsensitiveByDefault(): void
    {
        $errors = $this->lint(<<<'PHP'
<?php
class SomeTest {
    public function testCaps(): void {
        // ARRANGE
        $a = 1;
        // Act
        $b = $a;
        // assert
        $this->assertSame(1, $b);
    }
}
PHP);
        $this->assertSame([], $errors);
    }

    public function testGwtLabels(): void
    {
        $errors = $this->lint(
            <<<'PHP'
<?php
class SomeTest {
    public function testGwt(): void {
        // given
        $a = 1;
        // when
        $b = $a + 1;
        // then
        $this->assertSame(2, $b);
    }
}
PHP,
            [
                'labels' => [
                    'arrange' => ['given'],
                    'act'     => ['when'],
                    'assert'  => ['then'],
                ],
            ]
        );
        $this->assertSame([], $errors);
    }

    public function testJapaneseLabels(): void
    {
        $errors = $this->lint(
            <<<'PHP'
<?php
class SomeTest {
    public function testJp(): void {
        // 準備
        $a = 1;
        // 実行
        $b = $a + 1;
        // 検証
        $this->assertSame(2, $b);
    }
}
PHP,
            [
                'labels' => [
                    'arrange' => ['準備', '前準備'],
                    'act'     => ['実行'],
                    'assert'  => ['検証', '確認'],
                ],
            ]
        );
        $this->assertSame([], $errors);
    }

    public function testAllowEmptySectionFalseFlagsEmpty(): void
    {
        $errors = $this->lint(
            <<<'PHP'
<?php
class SomeTest {
    public function testEmpty(): void {
        // arrange
        // act
        $a = 1;
        // assert
        $this->assertSame(1, $a);
    }
}
PHP,
            ['allowEmptySection' => false]
        );
        $this->assertNotEmpty($errors);
        $messages = implode("\n", array_column($errors, 'message'));
        $this->assertStringContainsString('arrange', $messages);
    }

    public function testCaseSensitiveRejectsUppercase(): void
    {
        $errors = $this->lint(
            <<<'PHP'
<?php
class SomeTest {
    public function testCaps(): void {
        // ARRANGE
        $a = 1;
        // act
        $b = $a;
        // assert
        $this->assertSame(1, $b);
    }
}
PHP,
            ['caseSensitive' => true]
        );
        $this->assertCount(1, $errors);
        $this->assertStringContainsString('arrange', $errors[0]['message']);
    }
}
