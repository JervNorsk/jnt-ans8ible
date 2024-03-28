##  ------------------------------------------------------------------------
## |                              Ansible Bastion                           |
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
.MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))

# Tasks
help: ## Show this help
	@sed -ne '/@sed/!s/^## //p' $(MAKEFILE_LIST) | awk 'BEGIN {FS = "^.*?## "}; {printf "\033[32m  %s\033[0m\n", $$1}'
	@grep -Eh '\s##\s' $(MAKEFILE_LIST) | awk -F ':.*?##|\\|' '{printf "\033[34m  %25-s\033[36m%s\033[0m\n", $$1, $$2}'

# Services
override container_runtime = docker

ifndef with_service_project
override with_service_project = ansible
endif

ifndef with_service_host_os
override with_service_host_os = redhat
endif

ifndef with_service_host_build
override with_service_host_build = false
endif

service-host-build:
	export with_os=$(with_service_host_os); \
	export with_service_host=$(with_service_host); \
	$(container_runtime) compose -p $(with_service_project) -f /srv/services/host/docker-compose.yml \
		build

service-host:
	export with_os=$(with_service_host_os); \
	export with_service_host=$(with_service_host); \
	$(container_runtime) compose -p $(with_service_project) -f /srv/services/docker-compose.yml \
		up $(with_service_host)	-d \
			$(shell [ -z $(with_service_host_force_recreate) ] || [ "$(with_service_host_force_recreate)" == 'false' ] || echo --force-recreate)

service-host-up:
	export with_os=$(with_service_host_os); \
	export with_service_host=$(with_service_host); \
	$(container_runtime) compose -p $(with_service_project) -f /srv/services/docker-compose.yml \
		up $(with_service_host)	-d \
			$(shell [ -z $(with_service_host_force_recreate) ] || [ "$(with_service_host_force_recreate)" == 'false' ] || echo --force-recreate) \
			$(shell [ -z $(with_service_host_remove_orphans) ] || [ "$(with_service_host_remove_orphans)" == 'false' ] || echo --remove-orphans) \
			$(shell [ -z $(with_service_host_build) ] || [ "$(with_service_host_build)" == 'false' ] || echo --build) \

service-host-down:
	export with_os=$(with_service_host_os); \
	export with_service_host=$(with_service_host); \
	$(container_runtime) compose -p $(with_service_project) -f /srv/services/$(with_service_host)/docker-compose.yml \
		down

# Ansible
ifndef with_inventory
override with_inventory = /srv/storage/inventory
endif

as:
	@$(MAKE) --no-print-directory \
		service-host-up \
			with_service_host=as

as-wildfly: as ## Runs AS service with JBoss Wildfly from Ansible collection
	@$(MAKE) --no-print-directory -f /srv/services/as/Makefile \
		wildfly \
    		with_inventory=$(with_inventory) \
    		on_hosts=as

as-eap: as ## Runs AS service with JBoss EAP from Ansible collection
	@$(MAKE) --no-print-directory -f /srv/services/as/Makefile \
		eap \
			with_inventory=$(with_inventory) \
			on_hosts=as

db:
	@$(MAKE) --no-print-directory \
		service-host-up \
			with_service_host=db

db-mysql: db ## Runs DB service with MySQL from Ansible collection
	@$(MAKE) --no-print-directory -f /srv/services/db/Makefile \
		mysql \
			with_inventory=$(with_inventory) \
			on_hosts=db

db-oracle: db ## Runs DB service with Oracle from Ansible collection
	@$(MAKE) --no-print-directory -f /srv/services/db/Makefile \
		oracle \
			with_inventory=$(with_inventory) \
			on_hosts=db

idp:
	@$(MAKE) --no-print-directory \
		service-host-up \
			with_service_host=idp

idp-ldap: idp ## Runs IdP service with OpenLDAP from Ansible collection
	@$(MAKE) --no-print-directory -f /srv/services/idp/Makefile \
		ldap \
			with_inventory=$(with_inventory) \
			on_hosts=idp

proxy:
	@$(MAKE) --no-print-directory \
		service-host-up \
			with_service_host=proxy

proxy-apache2: proxy ## Runs Proxy service with Apache2 from Ansible collection
	@$(MAKE) --no-print-directory -f /srv/services/proxy/Makefile \
		apache2 \
			with_inventory=$(with_inventory) \
			on_hosts=proxy

ms: ## Runs a microservice service with Spring Boot from Ansible collection
	@$(MAKE) --no-print-directory -f /srv/services/proxy/Makefile \
		apache2 \
			with_inventory=$(with_inventory) \
			on_hosts=proxy
