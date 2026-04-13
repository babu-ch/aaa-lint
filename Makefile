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
# Usage: make release-eslint VERSION=0.0.2
release-eslint:
	@if [ -z "$(VERSION)" ]; then echo "usage: make release-eslint VERSION=x.y.z"; exit 1; fi
	scripts/release-eslint.sh $(VERSION)

release-rubocop:
	@if [ -z "$(VERSION)" ]; then echo "usage: make release-rubocop VERSION=x.y.z"; exit 1; fi
	scripts/release-rubocop.sh $(VERSION)

release-phpcs:
	@if [ -z "$(VERSION)" ]; then echo "usage: make release-phpcs VERSION=x.y.z"; exit 1; fi
	scripts/release-phpcs.sh $(VERSION)

release-all:
	@if [ -z "$(VERSION)" ]; then echo "usage: make release-all VERSION=x.y.z"; exit 1; fi
	scripts/release-all.sh $(VERSION)

# ---- housekeeping ---------------------------------------------------------
clean:
	rm -rf node_modules packages/*/node_modules \
	       packages/rubocop-aaa/vendor packages/rubocop-aaa/.bundle \
	       packages/phpcs-aaa/vendor packages/phpcs-aaa/composer.lock
