.PHONY: test test-node test-ruby test-php clean

test: test-node test-ruby test-php

test-node:
	docker compose run --rm node

test-ruby:
	docker compose run --rm ruby

test-php:
	docker compose run --rm php

clean:
	rm -rf node_modules packages/*/node_modules \
	       packages/rubocop-aaa/vendor packages/rubocop-aaa/.bundle \
	       packages/phpcs-aaa/vendor packages/phpcs-aaa/composer.lock
