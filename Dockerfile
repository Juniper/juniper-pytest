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

# Install python components in a virtual environment.
ADD Pipfile Pipfile.lock ./

RUN pipenv install

# Build a tight python image.  Should be same image as used to build.
FROM python:3.6-alpine3.9

# Copy modules we built into the image.
COPY --from=build .venv ./.venv/

# Set up pipenv environment
COPY --from=build Pipfile Pipfile.lock ./

# Put pipenv first in the path
ENV PATH=/.venv/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Install other stuff we need
RUN apk add --no-cache libxslt libxml2 libffi openssl curl \
    ca-certificates openssl \
    && rm -rf /source/* \
    && rm -rf /var/cache/apk/*

# Where we expect tests to be mounted.
VOLUME /tests
WORKDIR /tests

# Copy sample test into work directory.
# This is hidden if a test volume is mounted instead.
ADD test_sample.py /tests/

# By default, run through the pipenv.
ENTRYPOINT ["pytest"]
