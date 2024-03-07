##  ------------------------------------------------------------------------
## |                            JNT Ansible Console                         |
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

wildfly: ## Run Ansible jnt.wildfly with default setup
	@$(MAKE) -f /srv/ansible/collections/wildfly/Makefile \
		wildfly

eap: ## Run Ansible jnt.wildfly with EAP setup
	@$(MAKE) -f /srv/ansible/collections/wildfly/Makefile \
		eap
