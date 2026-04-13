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

    private const SECTION_HINTS = [
        'arrange' => 'before the code that sets up test state',
        'act'     => 'before the code that triggers the behavior under test',
        'assert'  => 'before the code that verifies the result',
    ];

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

        $missing = [];
        foreach (self::SECTIONS as $section) {
            if (!isset($found[$section])) {
                $missing[] = $section;
            }
        }

        if (count($missing) === count(self::SECTIONS)) {
            $this->reportAllMissing($phpcsFile, $stackPtr, $opener, $tokens);
            return;
        }

        if (!empty($missing)) {
            foreach ($missing as $section) {
                $this->reportMissingOne($phpcsFile, $stackPtr, $section);
            }
            return;
        }

        $prev = -1;
        foreach (self::SECTIONS as $section) {
            if ($found[$section] < $prev) {
                $phpcsFile->addError(
                    sprintf(
                        'AAA comments must appear in order: arrange -> act -> assert. Found "%s" after "arrange/act" — move it to the right place.',
                        $section
                    ),
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
                    sprintf(
                        'Section "%s" has no statements. Add code between // %s and the next section, or remove the // %s comment.',
                        $section,
                        $section,
                        $section
                    ),
                    $found[$section],
                    'EmptySection'
                );
            }
        }
    }

    private function reportAllMissing(File $phpcsFile, int $stackPtr, int $opener, array $tokens): void
    {
        $labels = [
            'arrange' => $this->preferredLabel('arrange'),
            'act'     => $this->preferredLabel('act'),
            'assert'  => $this->preferredLabel('assert'),
        ];

        $message = sprintf(
            'Missing arrange/act/assert section comments. Insert // %s, // %s, and // %s to mark each section (auto-fix scaffolds a template at the top of the method).',
            $labels['arrange'],
            $labels['act'],
            $labels['assert']
        );

        $fix = $phpcsFile->addFixableError($message, $stackPtr, 'MissingAll');
        if (!$fix) {
            return;
        }

        $indent = $this->detectIndent($phpcsFile, $opener);
        $template =
            "\n" . $indent . '// ' . $labels['arrange'] .
            "\n" . $indent . '// ' . $labels['act'] .
            "\n" . $indent . '// ' . $labels['assert'];

        $phpcsFile->fixer->addContent($opener, $template);
    }

    private function reportMissingOne(File $phpcsFile, int $stackPtr, string $section): void
    {
        $message = sprintf(
            'Missing "%s" comment. Insert // %s %s.',
            $section,
            $this->preferredLabel($section),
            self::SECTION_HINTS[$section]
        );
        $phpcsFile->addError($message, $stackPtr, 'Missing' . ucfirst($section));
    }

    private function detectIndent(File $phpcsFile, int $opener): string
    {
        $tokens = $phpcsFile->getTokens();
        // Prefer the indentation of the opener line + 4 spaces.
        // Walk back to find the line's leading whitespace.
        $line = $tokens[$opener]['line'];
        $start = $opener;
        while ($start > 0 && $tokens[$start - 1]['line'] === $line) {
            $start--;
        }
        $lead = '';
        if ($tokens[$start]['code'] === T_WHITESPACE) {
            $lead = str_replace("\n", '', $tokens[$start]['content']);
        }
        return $lead . '    ';
    }

    private function preferredLabel(string $section): string
    {
        return $this->labels[$section][0] ?? $section;
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
