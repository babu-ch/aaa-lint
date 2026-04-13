<?php

require __DIR__ . '/../vendor/autoload.php';
require __DIR__ . '/../vendor/squizlabs/php_codesniffer/autoload.php';
// PHPCS defines its T_* polyfill constants inside Util\Tokens; force-load it.
new \PHP_CodeSniffer\Util\Tokens();

if (!defined('PHP_CODESNIFFER_CBF')) {
    define('PHP_CODESNIFFER_CBF', false);
}
if (!defined('PHP_CODESNIFFER_VERBOSITY')) {
    define('PHP_CODESNIFFER_VERBOSITY', 0);
}

// Register the AAA standard path so Ruleset can find it by name.
\PHP_CodeSniffer\Config::setConfigData(
    'installed_paths',
    realpath(__DIR__ . '/..'),
    true
);
