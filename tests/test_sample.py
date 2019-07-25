#!env python3
# <*******************
#
# Copyright 2019 Juniper Networks, Inc. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#    http://www.apache.org/licenses/LICENSE-2.txt
# Unless required by applicable law or otherwise agreed to in writing by the
# parties, software distributed under the License is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
#
# *******************

import time


def inc(x):
    return x + 1


# All methods named "test_*" will be executed.
def test_answer():
    assert inc(3) == 4


# # This test is expected to fail.
# @pytest.mark.xfail(strict=True)
# def test_answer():
#     assert inc(3) == 5


def test_sleep():
    time.sleep(1)
