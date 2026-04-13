# Development

This is a multi-language monorepo (JS / Ruby / PHP). To avoid requiring every contributor to install three toolchains locally, **all tests run inside Docker**.

## Prerequisites

- Docker + Docker Compose

That's it. No local Node, Ruby, PHP, or Composer needed.

## Running tests

```bash
make test          # all three languages
make test-node     # eslint-plugin-aaa-pattern
make test-ruby     # rubocop-aaa
make test-php      # phpcs-aaa
```

Under the hood these run `docker compose run --rm <service>` against the services defined in `docker-compose.yml`:

| Service | Image | Workdir |
|---|---|---|
| `node` | `node:20-alpine` | repo root (npm workspaces) |
| `ruby` | `ruby:3.2-alpine` | `packages/rubocop-aaa` |
| `php` | `composer:2` | `packages/phpcs-aaa` |

The first run pulls images and installs dependencies into bind-mounted volumes (`node_modules`, `packages/rubocop-aaa/vendor/bundle`, `packages/phpcs-aaa/vendor`). Subsequent runs are fast.

## Dev Container (optional)

Opening the repo in VS Code with the Dev Containers extension will build a universal image pre-loaded with Node 20, Ruby 3.2, PHP 8.2, and Docker-in-Docker. See `.devcontainer/devcontainer.json`.

## Running locally (without Docker)

If you have the relevant toolchain installed you can also run tests directly:

```bash
# JS
npm test --workspace=eslint-plugin-aaa-pattern

# Ruby
cd packages/rubocop-aaa && bundle install && bundle exec rspec

# PHP
cd packages/phpcs-aaa && composer install && composer test
```

## Cleaning up

```bash
make clean   # remove node_modules, vendor/, .bundle/
```
