.PHONY: test

sandbox:
	podman-compose run --rm web rails console --sandbox
console:
	podman-compose run --rm web rails console
bash:
	podman-compose run --rm web bash
sh:
	podman-compose run --rm web sh
web:
	podman-compose run --rm --service-ports web
down:
	podman-compose down
restart:
	podman-compose restart
dbm:
	podman-compose run --rm web rails db:migrate
dbmt:
	podman-compose run --rm web rails db:migrate RAILS_ENV=test
bundle:
	podman-compose run --rm web bundle install
test:
	podman-compose run --rm test rails test $(f)
system-test:
	podman-compose run --rm test rails test test/system/*
routes:
	podman-compose run --rm web rails routes
logs:
	podman-compose logs -f
pid:
	podman-compose run --rm web rm /app/tmp/pids/server.pid
cache:
	podman-compose run --rm web rails dev:cache
