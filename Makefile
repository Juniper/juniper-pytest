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

.PHONY: clean build test docker-test docker-build docker-shell

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

# Build the docker container
PYTEST_DOCKER_REGISTRY=ps-docker-internal.artifactory.aslab.juniper.net
build:
	docker build -t $(PYTEST_DOCKER_REGISTRY)/pytest .

# Execute tests in a docker container
docker-test: build
	docker run --rm $(PYTEST_DOCKER_REGISTRY)/pytest

# Bash shell inside container for debugging
docker-shell: build
	docker run --rm --entrypoint=ash --interactive --tty $(PYTEST_DOCKER_REGISTRY)/pytest