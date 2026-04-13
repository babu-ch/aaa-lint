<?php

namespace AAA\Sniffs\Tests;

use PHP_CodeSniffer\Files\File;
use PHP_CodeSniffer\Sniffs\Sniff;

class PatternSniff implements Sniff
{
    /** @var array<string> Prefixes/names of test methods to inspect. A method matches if its name starts with any entry. */
    public $testFunctionPrefixes = ['test'];

    /** @var array<string,array<string>> */
    public $labels = [
        'arrange' => ['arrange'],
        'act'     => ['act'],
        'assert'  => ['assert'],
    ];

    /** @var bool */
    public $caseSensitive = false;

    /** @var bool */
    public $allowEmptySection = true;

    private const SECTIONS = ['arrange', 'act', 'assert'];

    public function register()
    {
        return [T_FUNCTION];
    }

    public function process(File $phpcsFile, $stackPtr)
    {
        $tokens = $phpcsFile->getTokens();

        $namePtr = $phpcsFile->findNext(T_STRING, $stackPtr);
        if ($namePtr === false) {
            return;
        }
        $name = $tokens[$namePtr]['content'];

        if (!$this->isTestMethod($name)) {
            return;
        }

        if (!isset($tokens[$stackPtr]['scope_opener'], $tokens[$stackPtr]['scope_closer'])) {
            return;
        }

        $opener = $tokens[$stackPtr]['scope_opener'];
        $closer = $tokens[$stackPtr]['scope_closer'];

        $found = [];
        for ($i = $opener + 1; $i < $closer; $i++) {
            if ($tokens[$i]['code'] !== T_COMMENT) {
                continue;
            }
            $section = $this->matchSection($tokens[$i]['content']);
            if ($section !== null && !isset($found[$section])) {
                $found[$section] = $i;
            }
        }

        foreach (self::SECTIONS as $section) {
            if (!isset($found[$section])) {
                $phpcsFile->addError(
                    sprintf('Missing "%s" comment in test method.', $section),
                    $stackPtr,
                    'Missing' . ucfirst($section)
                );
                return;
            }
        }

        $prev = -1;
        foreach (self::SECTIONS as $section) {
            if ($found[$section] < $prev) {
                $phpcsFile->addError(
                    'AAA comments must appear in order: arrange -> act -> assert.',
                    $found[$section],
                    'WrongOrder'
                );
                return;
            }
            $prev = $found[$section];
        }

        if ($this->allowEmptySection) {
            return;
        }

        $boundaries = [
            ['arrange', $found['arrange'], $found['act']],
            ['act',     $found['act'],     $found['assert']],
            ['assert',  $found['assert'],  $closer],
        ];

        foreach ($boundaries as [$section, $start, $end]) {
            if (!$this->hasCodeBetween($tokens, $start, $end)) {
                $phpcsFile->addError(
                    sprintf('Section "%s" has no statements.', $section),
                    $found[$section],
                    'EmptySection'
                );
            }
        }
    }

    private function isTestMethod(string $name): bool
    {
        $target = $this->caseSensitive ? $name : strtolower($name);
        foreach ($this->testFunctionPrefixes as $prefix) {
            $p = $this->caseSensitive ? $prefix : strtolower($prefix);
            if (strncmp($target, $p, strlen($p)) === 0) {
                return true;
            }
        }
        return false;
    }

    private function matchSection(string $commentText): ?string
    {
        $text = trim(preg_replace('#^(//|\#+|/\*+|\*+|\*/)\s*#', '', rtrim($commentText)));
        $text = rtrim($text, "*/ \t");
        $text = trim($text);
        $target = $this->caseSensitive ? $text : strtolower($text);

        foreach (self::SECTIONS as $section) {
            $candidates = $this->labels[$section] ?? [];
            foreach ($candidates as $label) {
                $l = $this->caseSensitive ? $label : strtolower($label);
                if ($target === $l) {
                    return $section;
                }
            }
        }
        return null;
    }

    private function hasCodeBetween(array $tokens, int $start, int $end): bool
    {
        for ($i = $start + 1; $i < $end; $i++) {
            $code = $tokens[$i]['code'];
            if ($code === T_WHITESPACE || $code === T_COMMENT || $code === T_DOC_COMMENT_STRING) {
                continue;
            }
            if (in_array($code, [T_DOC_COMMENT_OPEN_TAG, T_DOC_COMMENT_CLOSE_TAG, T_DOC_COMMENT_STAR, T_DOC_COMMENT_WHITESPACE], true)) {
                continue;
            }
            return true;
        }
        return false;
    }
}
