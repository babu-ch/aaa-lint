.PHONY: test test-node test-ruby test-php clean \
        release-eslint release-rubocop release-phpcs release-all

# ---- tests ----------------------------------------------------------------
test: test-node test-ruby test-php

test-node:
	docker compose run --rm node

test-ruby:
	docker compose run --rm ruby

test-php:
	docker compose run --rm php

# ---- releases -------------------------------------------------------------
# Bump the package's manifest version first, commit, then run.
# Each script reads the version from the manifest (no VERSION arg).
release-eslint:
	scripts/release-eslint.sh

release-rubocop:
	scripts/release-rubocop.sh

release-phpcs:
	scripts/release-phpcs.sh

release-all:
	scripts/release-all.sh

# ---- housekeeping ---------------------------------------------------------
clean:
	rm -rf node_modules packages/*/node_modules \
	       packages/rubocop-aaa/vendor packages/rubocop-aaa/.bundle \
	       packages/phpcs-aaa/vendor packages/phpcs-aaa/composer.lock
