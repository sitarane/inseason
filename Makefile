.PHONY: test

sandbox:
	docker-compose run --rm web rails console --sandbox
console:
	docker-compose run --rm web rails console
bash:
	docker-compose run --rm web bash
web:
	docker-compose run --rm --service-ports web
down:
	docker-compose down
restart:
	docker-compose restart
dbm:
	docker-compose run --rm web rails db:migrate
dbmt:
	docker-compose run --rm web rails db:migrate RAILS_ENV=test
bundle:
	docker-compose run --rm web bundle install
test:
	docker-compose run --rm test rails test $(f)
system-test:
	docker-compose run --rm test rails test:system
routes:
	docker-compose run --rm web rails routes
logs:
	docker-compose logs -f
pid:
	docker-compose run --rm web rm /app/tmp/pids/server.pid
