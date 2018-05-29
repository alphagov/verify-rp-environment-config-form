#!/usr/bin/env sh
set -eu #quits script on error

trap 'docker-compose down' EXIT

docker-compose build spec-tester
docker-compose up -d selenium-hub
docker-compose run -v $(pwd):/app:ro spec-tester spec/features/user_visits_form_smoke_spec.rb
