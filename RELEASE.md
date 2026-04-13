# Release procedure

This monorepo ships three packages to three different registries:

| Package | Registry | Source path |
|---|---|---|
| `eslint-plugin-aaa` | [npm](https://www.npmjs.com/) | `packages/eslint-plugin-aaa` |
| `rubocop-aaa` | [RubyGems](https://rubygems.org/) | `packages/rubocop-aaa` |
| `babu-ch/phpcs-aaa` | [Packagist](https://packagist.org/) | `packages/phpcs-aaa` |

Releases are **manual on purpose** — release frequency is low and we want a human to confirm each cut. All commands below run from the **monorepo root**.

## What "release" actually does

| Step | npm | RubyGems | Packagist |
|---|---|---|---|
| Bump version | edit `package.json` | edit `.gemspec` | (none — Packagist reads git tags) |
| Build artifact | npm packs `src/` | `gem build` produces `.gem` | `git subtree split` |
| Push | `npm publish` | `gem push` | push to split mirror + tag |
| User installs via | `npm install eslint-plugin-aaa@<v>` | `gem install rubocop-aaa -v <v>` | `composer require babu-ch/phpcs-aaa:<v>` |

Each release script also creates a per-package tag in the monorepo (`eslint-plugin-aaa-v<v>`, etc.) so `git log --tags` shows the release history.

## Pre-release checklist (every package)

1. `make test` — all three suites green.
2. Bump the version in the relevant manifest:
   - npm: `packages/eslint-plugin-aaa/package.json` (`version`)
   - RubyGems: `packages/rubocop-aaa/rubocop-aaa.gemspec` (`spec.version`)
   - Packagist: nothing — Packagist tracks the git tag pushed by the script.
3. Commit and push the bump (`chore: bump <pkg> to <v>`).
4. Run the appropriate release command below.

## Release commands

All run from the monorepo root.

```bash
make release-eslint  VERSION=0.0.2     # eslint-plugin-aaa -> npm
make release-rubocop VERSION=0.0.2     # rubocop-aaa -> RubyGems
make release-phpcs   VERSION=0.0.2     # phpcs-aaa -> Packagist (via split mirror)
make release-all     VERSION=0.0.2     # all three at the same version
```

Each script is also runnable directly: `scripts/release-eslint.sh 0.0.2`.

## What each script checks before publishing

All scripts:
- Refuse to run if the working tree is dirty.
- Refuse to run if you're not on `main`.
- Push a tag back to `origin` (`<package>-v<version>`).

`release-eslint.sh`:
- Verifies `package.json` version matches the `<version>` argument.
- Lets `npm publish`'s `prepublishOnly` hook run the test suite.
- Adds `--access public` automatically on the first publish (when the package does not yet exist on npm).

`release-rubocop.sh`:
- Verifies the gemspec version matches the `<version>` argument.
- Re-runs `rspec` via Docker before pushing.
- Cleans up the built `.gem` file even on failure.

`release-phpcs.sh`:
- Verifies the `phpcs-aaa-split` git remote is configured.
- Splits `packages/phpcs-aaa/` into a synthetic commit, pushes it to the split mirror's `main`, and tags `v<version>` there.

## One-time setup per machine / per person

| Registry | Setup |
|---|---|
| npm | `npm login` (npm.js account with publish access). 2FA enabled. |
| RubyGems | `gem signin` (RubyGems account with push access). 2FA enabled — gemspec sets `rubygems_mfa_required = 'true'`. |
| Packagist | `git remote add phpcs-aaa-split https://github.com/babu-ch/phpcs-aaa.git`. Packagist itself only needs to be told about the split repo once at the very first release (Submit the URL on packagist.org). |

## Why a Packagist split mirror?

- Packagist auto-discovers versions from git tags on the registered repo's **root** `composer.json`. There is no per-path option.
- A split mirror is the standard pattern for monorepo PHP packages (Symfony, Laravel, etc. all do this).
- The mirror is **distribution-only** — PRs and issues are not accepted there. Both its repo description and the in-package `README.md` link contributors back to this monorepo.

If the manual `subtree push` ever becomes a chore (release frequency goes up), the same flow can be automated via GitHub Actions + a deploy key on the split mirror. For now we keep it manual to avoid the secret-management overhead.
