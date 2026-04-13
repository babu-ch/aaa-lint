# Release procedure

This monorepo ships three packages to three different registries:

| Package | Registry | Source path |
|---|---|---|
| `eslint-plugin-aaa` | [npm](https://www.npmjs.com/) | `packages/eslint-plugin-aaa` |
| `rubocop-aaa` | [RubyGems](https://rubygems.org/) | `packages/rubocop-aaa` |
| `babu-ch/phpcs-aaa` | [Packagist](https://packagist.org/) | `packages/phpcs-aaa` |

Releases are **manual on purpose** — release frequency is low and we want a human to confirm each cut.

## Common pre-release checklist

1. `make test` — all three suites green.
2. Bump the version in the package's manifest:
   - npm: `packages/eslint-plugin-aaa/package.json` (`version`)
   - RubyGems: `packages/rubocop-aaa/rubocop-aaa.gemspec` (`spec.version`)
   - Packagist: `packages/phpcs-aaa/composer.json` — Packagist reads versions from git tags only, no manifest bump needed.
3. Update the package's CHANGELOG (TODO once we have one).
4. Commit and push the bump to `main`.

---

## Releasing `eslint-plugin-aaa` to npm

```bash
cd packages/eslint-plugin-aaa
npm publish
```

First publish requires `npm publish --access public`. 2FA enabled on the npm account.

## Releasing `rubocop-aaa` to RubyGems

```bash
cd packages/rubocop-aaa
gem build rubocop-aaa.gemspec
gem push rubocop-aaa-<version>.gem
rm rubocop-aaa-<version>.gem
```

The gemspec sets `rubygems_mfa_required = 'true'` so RubyGems will require 2FA on push.

## Releasing `phpcs-aaa` to Packagist

Packagist requires `composer.json` at the **root** of a repository, but ours lives in `packages/phpcs-aaa/`. To bridge that gap we keep a **read-only split mirror** at <https://github.com/babu-ch/phpcs-aaa> and push to it manually at release time.

### One-time setup (per machine)

```bash
git remote add phpcs-aaa-split git@github.com:babu-ch/phpcs-aaa.git
```

(SSH must be configured for GitHub on the machine; HTTPS is fine too — substitute the URL.)

### At each release

From the repo root, on `main`:

```bash
scripts/release-phpcs.sh <version>   # e.g. scripts/release-phpcs.sh 0.0.2
```

The script does:

1. `git subtree split --prefix=packages/phpcs-aaa main` — synthesizes a commit whose tree is just `packages/phpcs-aaa/`.
2. Pushes that commit to the split mirror's `main`.
3. Tags it `v<version>` on the split mirror.

Packagist's GitHub webhook picks up the new tag within a minute and the new version goes live at <https://packagist.org/packages/babu-ch/phpcs-aaa>.

### Why a split mirror?

- Packagist auto-discovers versions from git tags on the registered repo's root `composer.json`. There is no per-path option.
- A split mirror is the standard pattern for monorepo PHP packages (Symfony, Laravel, etc. all do this).
- The mirror is **distribution-only**: PRs and issues are not accepted there. Its README and the in-package `README.md` both link back to this monorepo.

If the manual `subtree push` ever becomes a chore (release frequency goes up), the same flow can be automated via GitHub Actions + a deploy key on the split mirror. For now we keep it manual to avoid the secret-management overhead.
