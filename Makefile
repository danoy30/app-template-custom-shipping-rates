SHELL := /usr/bin/env bash

check_uid_set:
	if [ -z "$(UID)" ]; then echo "UID variable required, please run 'export UID' before running make task"; exit 1 ; fi
	if [ -z "$(WIX_NGROK_DOMAIN)" ]; then echo "WIX_NGROK_DOMAIN variable required, please set it up in your shell"; exit 1 ; fi

up: check_uid_set npm_install
	export UID && docker-compose up -d --force-recreate
	bin/wait_for_docker.bash "Ready in"

logs_tail: check_uid_set
	export UID && docker-compose logs -f

down:
	docker-compose down

build:
	docker-compose build

bash:
	export UID && docker-compose run --rm node bash

npm_install:
	export UID && docker-compose run --rm node npm install

npm_watch:
	export UID && docker-compose run --rm node npm run watch

npm_build:
	export UID && docker-compose run --rm node npm run build

npm_lint:
	export UID && docker-compose run --rm node npm run lint

npm_audit: check_uid_set
	export UID && docker-compose run --rm node npm audit

npm_audit_fix: check_uid_set
	export UID && docker-compose run --rm node npm audit fix

docker_clean:
	docker rm $(docker ps -a -q) || true
	docker rmi < echo $(docker images -q | tr "\n" " ")

ngrok_free:
	ngrok http

ngrok_static: check_uid_set
	ngrok http --domain="$(WIX_NGROK_DOMAIN)" 3000
