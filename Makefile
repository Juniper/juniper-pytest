#!make
# <*******************
#
# Copyright 2019 Juniper Networks, Inc. All rights reserved.
# Licensed under the Apache License Version 2.0, January 2004 (the "License")
# You may not use this script file except in compliance with the License, which is located at
# http://www.juniper.net/support/legal/scriptlicense/
# Unless required by applicable law or otherwise agreed to in writing by the parties, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# *******************>

# Container version
VERSION := 1.0.0

# Execute tests (dev environment)
.PHONY: test
test: .venv
	pipenv run sh -c 'cd tests && py.test'

# Create pipenv
export PIPENV_VENV_IN_PROJECT=1
export PIPENV_FILE=$(CURDIR)
.venv:
	which pipenv || pip3 install pipenv
	pipenv install --dev
	pipenv run make -f ansible-setup.mak

# Like setting ansible_python_interpreter as inventory variable.
# Necessary for ansible provisioning for Vagrant tests.
export ANSIBLE_PYTHON_INTERPRETER := python3 

# Update the pip modules to latest, constrained only by requirements in Pipfile
.PHONY: update-pipenv
update-pipenv: .venv
	pipenv update --dev

# Remove the virtual-env (not the vagrant VMs).
.PHONY: clean
clean:
	rm -rf .venv

# Build the docker container
PYTEST_DOCKER_REGISTRY=ps-docker-internal.artifactory.aslab.juniper.net
.PHONY: build
build:
	git clean -dXf tests
	docker build -t $(PYTEST_DOCKER_REGISTRY)/pytest .

# Execute tests in a docker container
.PHONY: docker-test
docker-test: build
	docker run --rm $(PYTEST_DOCKER_REGISTRY)/pytest

# Utility to run in the docker container
# $(1): Alternate entrypoint.
# $(2,3,...): Arguments to $(1).
docker-run = docker run --rm --entrypoint="$(1)" $(PYTEST_DOCKER_REGISTRY)/pytest $(2) $(3) $(4) $(5) $(6) $(7) $(8) $(9) $(10)

# ash shell inside container for debugging
.PHONY: docker-shell
docker-shell: build
	docker run --rm --entrypoint=ash --interactive --tty $(PYTEST_DOCKER_REGISTRY)/pytest

module_version = $(call docker-run,pip,list) | grep '^$(1) ' | awk '{print $$2}'

# Version of this container.  Used to tag the image built in CI.
.PHONY: version
version:
	@echo $(VERSION)

.PHONY: python-version
python-version:
	@$(call docker-run,python,--version) | awk '{print $$2}'

.PHONY: ansible-version
ansible-version:
	@$(call module_version,ansible)

.PHONY: alpine-version
alpine-version:
	@$(call docker-run,cat,/etc/alpine-release)

.PHONY: junos-eznc-version
junos-eznc-version:
	@$(call module_version,junos-eznc)

.PHONY: jsnapy-version
jsnapy-version:
	@$(call module_version,jsnapy)

# Update the vqfx10k-vagrant subtree from remote.
VQFX10K_VAGRANT_REMOTE ?= https://github.com/Juniper/vqfx10k-vagrant.git
.PHONY: update-vqfx10k-vagrant
update-vqfx10k-vagrant:
	git pull --squash -s subtree -Xsubtree=examples/vqfx10k-vagrant/ --allow-unrelated-histories -Xtheirs $(VQFX10K_VAGRANT_REMOTE) master

vagrant_base_dir := $(CURDIR)/examples/vqfx10k-vagrant

# Strip off deploy/halt/destroy from target name.
vagrant_target_dir = $(shell echo $@ | cut -d- '-f2,3,4,5')
# Enter into vagrant directory and run the command.
# Set path to ensure we get the expected version of Ansible for provisioning.
vagrant_command = VAGRANT_CWD="$(vagrant_base_dir)/$(vagrant_target_dir)" pipenv run vagrant $(1) $(2) $(3)
# Same as above, but pass topology in
# $(1): topology to run command for (e.g.- light-2qfx)
vagrant_command_topology = VAGRANT_CWD="$(vagrant_base_dir)/$(1)" pipenv run vagrant $(2) $(3) $(4)

# Deploy one qfx
.PHONY: up-light-1qfx halt-light-1qfx destroy-light-1qfx
up-light-1qfx: .venv
	$(call vagrant_command,up,--provision)
halt-light-1qfx: .venv
	$(call vagrant_command,halt)
destroy-light-1qfx: .venv
	$(call vagrant_command,destroy,--force)

# Deploy two qfx connected back-to-back
.PHONY: up-light-2qfx halt-light-2qfx destroy-light-2qfx
up-light-2qfx: .venv
	$(call vagrant_command,up,--provision)
halt-light-2qfx: .venv
	$(call vagrant_command,halt)
destroy-light-2qfx: .venv
	$(call vagrant_command,destroy,--force)

# Deploy two qfx connected back-to-back each connected to an ubuntu host
.PHONY: up-light-2qfx-2srv halt-light-2qfx-2srv destroy-light-2qfx-2srv
up-light-2qfx-2srv: .venv
	$(call vagrant_command,up,--provision)
halt-light-2qfx-2srv: .venv
	$(call vagrant_command,halt)
destroy-light-2qfx-2srv: .venv
	$(call vagrant_command,destroy,--force)

# Deploy spine and leaf topology with 2 spines and 3 leaves, one server per leaf
.PHONY: up-light-ipfabric-2S-3L halt-light-ipfabric-2S-3L destroy-light-ipfabric-2S-3L
up-light-ipfabric-2S-3L: .venv
	$(call vagrant_command,up,--provision)
halt-light-ipfabric-2S-3L: .venv
	$(call vagrant_command,halt)
destroy-light-ipfabric-2S-3L: .venv
	$(call vagrant_command,destroy,--force)

# Deploy one full qfx
.PHONY: up-full-1qfx halt-full-1qfx destroy-full-1qfx
up-full-1qfx: .venv
	$(call vagrant_command,up,--provision)
halt-full-1qfx: .venv
	$(call vagrant_command,halt)
destroy-full-1qfx: .venv
	$(call vagrant_command,destroy,--force)

# Deploy one full qfx connected to one server
.PHONY: up-full-1qfx-1srv halt-full-1qfx-1srv destroy-full-1qfx-1srv
up-full-1qfx-1srv: .venv
	$(call vagrant_command,up,--provision)
halt-full-1qfx-1srv: .venv
	$(call vagrant_command,halt)
destroy-full-1qfx-1srv: .venv
	$(call vagrant_command,destroy,--force)

# Deploy two full qfx connected back-to-back
.PHONY: up-full-2qfx halt-full-2qfx destroy-full-2qfx
up-full-2qfx: .venv
	$(call vagrant_command,up,--provision)
halt-full-2qfx: .venv
	$(call vagrant_command,halt)
destroy-full-2qfx: .venv
	$(call vagrant_command,destroy,--force)

# Deploy two full qfx connected back-to-back each connected to one server
.PHONY: up-full-2qfx-4srv-evpnvxlan halt-full-2qfx-4srv-evpnvxlan destroy-full-2qfx-4srv-evpnvxlan
up-full-2qfx-4srv-evpnvxlan: .venv
	$(call vagrant_command,up,--provision)
halt-full-2qfx-4srv-evpnvxlan: .venv
	$(call vagrant_command,halt)
destroy-full-2qfx-4srv-evpnvxlan: .venv
	$(call vagrant_command,destroy,--force)

# Deploy four full qfx in full mesh
.PHONY: up-full-4qfx halt-full-4qfx destroy-full-4qfx
up-full-4qfx: .venv
	$(call vagrant_command,up,--provision)
halt-full-4qfx: .venv
	$(call vagrant_command,halt)
destroy-full-4qfx: .venv
	$(call vagrant_command,destroy,--force)

# Deploy spine and leaf topology with 2 spines and 3 leaves, one server per leaf
.PHONY: up-full-ipfabric-2S-3L halt-full-ipfabric-2S-3L destroy-full-ipfabric-2S-3L
up-full-ipfabric-2S-3L: .venv
	$(call vagrant_command,up,--provision)
halt-full-ipfabric-2S-3L: .venv
	$(call vagrant_command,halt)
destroy-full-ipfabric-2S-3L: .venv
	$(call vagrant_command,destroy,--force)

# Path to vagrant ansible inventory.
# $(1): Name of topology (e.g.- light-2qfx)
vagrant_ansible_inventory = $(vagrant_base_dir)/$(1)/.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory

# Determine topology (e.g.- light-2qfx) from the ansible inventory file
# $(1): Path to Ansible inventory file
vagrant_topology = $(shell echo $(1) | awk -F/ '{topology=NF-5; print $$topology}')

# Make any vagrant_ansible_inventory:
%/vagrant_ansible_inventory:
	make up-$(call vagrant_topology,$@)

# Examples directory
examples_dir := $(CURDIR)/examples

# Test examples.  Arguments are passed in via pytest.ini
.PHONY: test-examples
test-examples: $(call vagrant_ansible_inventory,light-2qfx)
	pipenv run py.test
