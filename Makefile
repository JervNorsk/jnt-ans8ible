##  ------------------------------------------------------------------------
## |                              Ansible                                   |
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

ifndef container_runtime
override container_runtime = podman
endif

ifndef force_recreate
override force_recreate = false
endif

ifndef clean
override clean = false
endif

ifndef with_project
override with_project = ansible
endif

ifndef with_os
override with_os = redhat
endif

ifndef with_iac
override with_iac = euforlegal-lite
endif

ifndef build
override build = false
endif

ifndef as_host_state
override as_host_state = up
endif

# Services
define bastion-run
	set with_os=$(with_os) \
	&& \
	set with_service_host="bastion" \
	&& \
	$(container_runtime) compose -p $(with_project) -f ./services/docker-compose.yml \
    		run --rm \
    			bastion $(1)
endef

define bastion-make
	$(call bastion-run, \
		make $(1) \
			with_service_project=$(with_project) \
			with_service_host_os=$(with_os) \
			with_service_host_build=$(build) \
			with_service_host_force_recreate=$(force_recreate) \
			with_service_host_remove_orphans=$(clean) \
	)
endef

define host-bash
	$(container_runtime) compose -p $(with_project) \
			exec $(1) \
				bash
endef

bastion-build: ## Builds the bastion service
	$(container_runtime) compose -p $(with_project) -f ./services/docker-compose.yml \
 		build

bastion: ## Runs the bastion service to access Ansible
	$(call bastion-run, bash)

as: ## Runs AS service with JBoss Wildfly from Ansible collection
	$(call bastion-make, \
		as-wildfly \
			with_configuration_files=/srv/iac/$(with_iac)/services/as/init/config.dir/ \
			with_lib_files=/srv/iac/$(with_iac)/services/as/init/lib/ \
			with_cli_files=/srv/iac/$(with_iac)/services/as/init/cli/standalone/ \
			with_module_files=/srv/iac/$(with_iac)/services/as/init/module/ \
			with_deployment_files=/srv/iac/$(with_iac)/services/as/startup/deploy/ \
	)

as-bash: ## Access to AS service with a bash session
	$(call host-bash, as)

db: ## Runs DB service with MySQL from Ansible collection
	$(call bastion-make, \
		db-mysql \
			with_db_files=/srv/iac/$(with_iac)/services/db/init/schema/ \
	)

db-bash: ## Access to Proxy service with a bash session
	$(call host-bash, db)

ldap: ## Runs IdP service with OpenLDAP from Ansible collection
	$(call bastion-make, \
		idp-ldap \
	)

ldap-bash: ## Access to Proxy service with a bash session
	$(call host-bash, idp)

proxy: ## Runs Proxy service with Apache2 from Ansible collection
	$(call bastion-make, \
		proxy-apache2 \
			with_site_files=/srv/iac/$(with_iac)/services/proxy/init/sites/ \
			with_site_enabled=000_default.conf \
			with_config_files=/srv/iac/$(with_iac)/services/proxy/init/config/ \
	)

proxy-bash: ## Access to Proxy service with a bash session
	$(call host-bash, proxy)
