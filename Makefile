#!make
# <*******************
#
# Copyright 2019 Juniper Networks, Inc. All rights reserved.
# Licensed under the Juniper Networks Script Software License (the "License").
# You may not use this script file except in compliance with the License, which is located at
# http://www.juniper.net/support/legal/scriptlicense/
# Unless required by applicable law or otherwise agreed to in writing by the parties, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# *******************>

.PHONY: clean build test docker-test docker-shell version python-version alpine-version ansible-version junos-eznc-version jsnapy-version

# Execute tests (dev environment)
test: .venv
	pipenv run pytest

# Create pipenv
export PIPENV_VENV_IN_PROJECT=1
.venv:
	pipenv install --dev

# Remove all files ignored by git (not untracked/new).
clean:
	git clean -dXf
	rm -rf .venv

# Build the docker container
PYTEST_DOCKER_REGISTRY=ps-docker-internal.artifactory.aslab.juniper.net
build:
	docker build -t $(PYTEST_DOCKER_REGISTRY)/pytest .

# Execute tests in a docker container
docker-test: build
	docker run --rm $(PYTEST_DOCKER_REGISTRY)/pytest

# Utility to run in the docker container
# $(1): Alternate entrypoint.
# $(2,3,...): Arguments to $(1).
docker-run = docker run --rm --entrypoint="$(1)" $(PYTEST_DOCKER_REGISTRY)/pytest $(2) $(3) $(4) $(5) $(6) $(7) $(8) $(9) $(10)

# Bash shell inside container for debugging
docker-shell: build
	docker run --rm --entrypoint=ash --interactive --tty $(PYTEST_DOCKER_REGISTRY)/pytest

module_version = $(call docker-run,pip,list) | grep '^$(1) ' | awk '{print $$2}'

# Version of this container.  Used to tag the image built in CI.
version:
	@echo 0.1.1

python-version:
	@$(call docker-run,python,--version) | awk '{print $$2}'

ansible-version:
	@$(call module_version,ansible)

alpine-version:
	@$(call docker-run,cat,/etc/alpine-release)

junos-eznc-version:
	@$(call module_version,junos-eznc)

jsnapy-version:
	@$(call module_version,jsnapy)

