##  ------------------------------------------------------------------------
## |                              Ansible Console                          |
##  ------------------------------------------------------------------------
## Usage:
##   make [command] [arguments]
## ---
## Available commands:                                                      |

# Environments
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Configurations
.PHONY: help
.DEFAULT_GOAL := help

# Tasks
help: ## Show this help
	@sed -ne '/@sed/!s/^## //p' $(MAKEFILE_LIST) | awk 'BEGIN {FS = "^.*?## "}; {printf "\033[32m  %s\033[0m\n", $$1}'
	@grep -Eh '\s##\s' $(MAKEFILE_LIST) | awk -F ':.*?##|\\|' '{printf "\033[34m  %25-s\033[36m%s\033[0m\n", $$1, $$2}'

# Services

ifndef service_project
override service_project = ansible
endif

ifndef with_os
override with_os = redhat
endif

service-host-build:
	@docker compose -f /srv/services/host/docker-compose.yml \
		-p $(service_project) \
		build

service-host-up:
	@docker compose -f /srv/services/$(with_service)/docker-compose.yml \
		-p $(service_project) \
		up \
			-d

service-host-down:
	@docker compose -f /srv/services/$(with_service)/docker-compose.yml \
		-p $(service_project) \
		down

# Ansible

ifndef with_inventory
override with_inventory = ./inventory
endif

wildfly: ## Run Ansible jnt.wildfly with default setup
	@$(MAKE) service-host-up \
		with_service=as
	@$(MAKE) -f /srv/ansible/collections/wildfly/Makefile \
		wildfly \
			on_hosts=as

eap: ## Run Ansible jnt.wildfly with EAP setup
	@$(MAKE) service-host-up \
		with_service=as
	@$(MAKE) -f /srv/ansible/collections/wildfly/Makefile \
		eap \
			on_hosts=as
