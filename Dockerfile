# Copyright 2019 Juniper Networks, Inc. All rights reserved.
# Licensed under the Juniper Networks Script Software License (the "License").
# You may not use this script file except in compliance with the License, which is located at
# http://www.juniper.net/support/legal/scriptlicense/
# Unless required by applicable law or otherwise agreed to in writing by the parties,
# software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
# either express or implied.

FROM python:3.6-alpine3.9 AS build

# Install what we need to build.
RUN sh -c "apk add build-base python3-dev libxslt-dev libxml2-dev libffi-dev openssl-dev"

# Install pipenv
RUN pip install pipenv

# Create .venv in current directory.
ENV PIPENV_VENV_IN_PROJECT=1
# Ensure python logging happens immediately.
ENV PYTHONUNBUFFERED=1
# No .pyc files to save space and avoid writes to disk
ENV PYTHONDONTWRITEBYTECODE=1

# Install python components into /.venv
WORKDIR /
ADD Pipfile Pipfile.lock /
RUN pipenv install

# Remove *.pyc (Python byte-code cache) files
RUN find .venv -name __pycache__ -type d | xargs rm -rf
# Remove the documentation from the container
RUN find .venv -name docs -type d | xargs rm -rf

# Build a tight python image.  Should be same base image as used to build.
FROM python:3.6-alpine3.9

# Install other stuff we need
RUN apk add --no-cache libxslt libxml2 libffi curl ca-certificates openssl \
    && rm -rf /source/* \
    && rm -rf /var/cache/apk/*

# Copy Pipfile and Pipfile.lock for reference
COPY --from=build Pipfile Pipfile.lock /

# Copy modules we built from prior stage
COPY --from=build .venv /.venv/

# Put pipenv first in the path
ENV PATH=/.venv/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Where we expect tests to be mounted.
VOLUME /tests
WORKDIR /tests

# Copy sample tests into test directory.
# This is hidden if a test volume is mounted instead.
ADD tests /tests

# Where we expect to report test results.
# TODO: ADD...

# By default, run through the pipenv.
# Should discover and execute the sample tests.
ENTRYPOINT ["py.test"]
