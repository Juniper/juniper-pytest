#!env python3
# <*******************
#
# Copyright 2019 Juniper Networks, Inc. All rights reserved.
# Licensed under the Apache License Version 2.0, January 2004 (the "License")
# You may not use this script file except in compliance with the License, which
# is located at http://www.juniper.net/support/legal/scriptlicense/
# Unless required by applicable law or otherwise agreed to in writing by the
# parties, software distributed under the License is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
#
# ******************

from jnpr.junos import Device
from jnpr.junos.op.ethport import EthPortTable


# Get all the host variables
def get_host_vars(hosts, host_name):
    return hosts.options['inventory_manager'].get_host(host_name).get_vars()


# Return only variables needed to connect to Junos device
def dict_host_conn(host_vars):
    # strip leading 'ansible_' from the variable names
    return {k[len('ansible_'):]: v for (k, v) in host_vars.items() if k in
            ["ansible_host", "ansible_port", "ansible_user",
             "ansible_password", "ansible_ssh_private_key_file"]}


# Get only the host connection variables
def get_host_conn(hosts, host_name):
    return dict_host_conn(get_host_vars(hosts, host_name))


# Validate that the host entries looks correct
def assert_inventory_valid(hosts, vqfx):
    # Make sure expected host is in the inventory.
    assert vqfx in hosts

    # Minimal validation on the vqfx host
    vqfx_vars = get_host_vars(hosts, vqfx)
    assert (vqfx_vars['ansible_host'] == '127.0.0.1')
    assert (vqfx_vars['ansible_port'] >= 2000)
    assert (vqfx_vars['ansible_user'] == 'vagrant')


def test_get_inventory(ansible_adhoc):
    # Returns HostManager class which describes the inventory.
    # Use this to access metadata in the inventory (if any)
    hosts = ansible_adhoc()

    # Make sure there are the expected number of vqfx hosts
    assert(len(hosts) == 2)

    # Basic validation of inventory data
    assert_inventory_valid(hosts, 'vqfx1')
    assert_inventory_valid(hosts, 'vqfx2')


def test_junos_alarms(ansible_adhoc):
    hosts = ansible_adhoc()
    assert_no_junos_alarms(**get_host_conn(hosts, 'vqfx1'))
    assert_no_junos_alarms(**get_host_conn(hosts, 'vqfx2'))


def assert_no_junos_alarms(**connection_args):
    with Device(**connection_args) as dev:

        # Check for chassis alarms
        chassis_alarms = dev.rpc.get_alarm_information()
        assert(len(chassis_alarms.xpath(
                '//alarm-information/alarm-summary/no-active-alarms')) == 1)

        # Check for system alarms
        system_alarms = dev.rpc.get_system_alarm_information()
        assert(len(system_alarms.xpath(
                '//alarm-information/alarm-summary/no-active-alarms')) == 1)


def assert_interfaces_up(conn, interface):
    with Device(**conn) as dev:
        eths = EthPortTable(dev)
        eths.get(interface)
        for eth in eths:
            assert(eth.oper == 'up' and eth.admin == 'up')


def test_interfaces_up(ansible_adhoc):
    hosts = ansible_adhoc()

    vqfx1_conn = get_host_conn(hosts, 'vqfx1')
    assert_interfaces_up(vqfx1_conn, 'em*')

    vqfx2_conn = get_host_conn(hosts, 'vqfx2')
    assert_interfaces_up(vqfx2_conn, 'em*')


def assert_junos_version(conn, version):
    with Device(**conn) as dev:
        assert(dev.facts['version_info'].major >= version)


def test_junos_version(ansible_adhoc):
    hosts = ansible_adhoc()

    vqfx1_conn = get_host_conn(hosts, 'vqfx1')
    assert_junos_version(vqfx1_conn, (17, 4))

    vqfx2_conn = get_host_conn(hosts, 'vqfx2')
    assert_junos_version(vqfx2_conn, (17, 4))
