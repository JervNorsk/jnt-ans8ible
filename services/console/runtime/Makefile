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

ifndef as_state
override as_state = up
endif

ifndef with_name
override with_name = wildfly
endif

ifndef with_version
override with_version = 28.0.1.Final
endif

ifndef as_offline
override as_offline = false
endif

ifndef with_bind_addr
override with_bind_addr = 0.0.0.0
endif

ifndef with_bind_addr_management
override with_bind_addr_management = 0.0.0.0
endif

eap: ## Run JBoss Wildfly from JNT collection
	$(MAKE) wildfly \
		with_name="jboss-eap" \
		with_version="7.4" \
		as_offline=true

wildfly: ## Run JBoss Wildfly from JNT collection
	@ansible-playbook /srv/ansible/collections/wildfly/playbook.yml \
        -i inventory \
        -e on_hosts=$(on_hosts) \
        -t $(as_state) \
        -e as_offline=$(as_offline) \
        -e wildfly_name=$(with_name) \
        -e wildfly_version=$(with_version) \
        -e wildfly_bind_addr=$(with_bind_addr) \
        -e wildfly_bind_addr_management=$(with_bind_addr_management) \
        -e apply_cli=$(apply_cli) \
        -vv

wildfly-community: ## Install JBoss Wildfly from Ansible Community collection
	@ansible-playbook middleware_automation.wildfly.playbook \
		-i inventory \
		-e wildfly_version=$(wildfly_version) \
		-e wildfly_install_workdir=$(wildfly_workdir)/ \
		-e wildfly_user=$(wildfly_user) \
		-e wildfly_java_package_name=java-$(java_version)-openjdk-headless \
		-e wildfly_bind_addr_management=0.0.0.0
