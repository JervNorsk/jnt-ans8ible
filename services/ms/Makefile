##  ------------------------------------------------------------------------
## |                       Ansible Proxy Collection                        |
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

apache2: ## Runs Apache2 from Ansible collection
	ansible-playbook /srv/ansible/collections/apache2/playbook.yml \
        -i $(with_inventory) \
        -e on_hosts=$(on_hosts) \
        -t $(as_state) \
#        -vv
