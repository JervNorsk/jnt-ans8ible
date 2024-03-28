##  ------------------------------------------------------------------------
## |                   Ansible JBoss Wildfly Collection                    |
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

ifndef with_inventory
    $(error Argument with_inventory is not provided. Please provide with_inventory=<path>)
endif

ifndef on_hosts
    $(error Argument on_hosts is not provided. Please provide on_hosts=<hostname>)
endif

ifndef as_state
override as_state = up
endif

ifndef with_version
override with_version = 28.0.1.Final
endif

eap: ## Runs JBoss EAP from Ansible collection
	@$(MAKE) --no-print-directory -f $(.MAKEFILE) \
		wildfly \
			with_name="jboss-eap" \
			with_version="7.4" \
			as_offline=true \

wildfly: ## Runs JBoss Wildfly from Ansible collection
	ansible-playbook /srv/ansible/collections/wildfly/playbook.yml \
        -i $(with_inventory) \
        -e on_hosts=$(on_hosts) \
        -t $(as_state) \
        $(shell [ -z "$(as_offline)" ] || echo "-e as_offline=$(as_offline)") \
        $(shell [ -z "$(with_name)" ] || echo "-e wildfly_name=$(with_name)") \
        $(shell [ -z "$(with_version)" ] || echo "-e wildfly_version=$(with_version)") \
        $(shell [ -z "$(with_bind_addr)" ] || echo "-e wildfly_bind_addr=$(with_bind_addr)") \
        $(shell [ -z "$(with_bind_addr_management)" ] || echo "-e wildfly_bind_addr_management=$(with_bind_addr_management)") \
        $(shell [ -z "$(deploy_files)" ] || echo "-e deploy_files=$(deploy_files)") \
        $(shell [ -z "$(with_configuration_files)" ] || echo "-e wildfly_configuration_files=$(with_configuration_files)") \
        $(shell [ -z "$(with_lib_files)" ] || echo "-e wildfly_lib_files=$(with_lib_files)") \
        $(shell [ -z "$(with_cli_files)" ] || echo "-e wildfly_cli_files=$(with_cli_files)") \
        $(shell [ -z "$(with_module_files)" ] || echo "-e wildfly_module_files=$(with_module_files)") \
        $(shell [ -z "$(with_deployment_files)" ] || echo "-e wildfly_deployment_files=$(with_deployment_files)") \
#        -vv
