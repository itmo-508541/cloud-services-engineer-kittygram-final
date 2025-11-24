SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: migrate
migrate:
	@python manage.py migrate

.PHONY: collectstatic
collectstatic:
	@echo yes | python manage.py collectstatic
