.PHONY: install test server run

install:
	bundle
	touch .env
	touch .env.development
	touch .env.test
	touch .env.production

run:
	RACK_ENV=development bundle exec puma -C app/config/puma.rb

build:
	RACK_ENV=production bundle exec rake webpack:build

run_production:
	RACK_ENV=production bundle exec rake webpack:build
	RACK_ENV=production bundle exec puma -C app/config/puma.rb
