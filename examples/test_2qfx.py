from jnpr.junos import Device


# Get all the host variables
def get_host_vars(hosts, host_name):
    return hosts.options['inventory_manager'].get_host(host_name).get_vars()


# Return only variables needed to connect to Junos device
def dict_host_connection_vars(host_vars):
    # strip leading 'ansible_' from the variable names
    return {k[len('ansible_'):]: v for (k, v) in host_vars.items() if k in
            ["ansible_host", "ansible_port", "ansible_user", "ansible_password", "ansible_ssh_private_key_file"]}


# Get only the host connection variables
def get_host_connection_vars(hosts, host_name):
    return dict_host_connection_vars(get_host_vars(hosts, host_name))


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
    assert_no_junos_alarms(**get_host_connection_vars(hosts, 'vqfx1'))
    assert_no_junos_alarms(**get_host_connection_vars(hosts, 'vqfx2'))


def assert_no_junos_alarms(**connection_args):
    with Device(**connection_args) as dev:

        # Check for chassis alarms
        chassis_alarms = dev.rpc.get_alarm_information()
        assert(len(chassis_alarms.xpath('//alarm-information/alarm-summary/no-active-alarms')) == 1)

        # Check for system alarms
        system_alarms = dev.rpc.get_system_alarm_information()
        assert(len(system_alarms.xpath('//alarm-information/alarm-summary/no-active-alarms')) == 1)


def test_interfaces_up(ansible_adhoc):
    hosts = ansible_adhoc()

    vqfx1_connection_vars = get_host_connection_vars(hosts, 'vqfx1')
    vqfx2_connection_vars = get_host_connection_vars(hosts, 'vqfx2')

    with Device(**vqfx1_connection_vars) as vqfx1:
        # TODO

        with Device(**vqfx2_connection_vars) as vqfx2:
                # TODO
                return


def test_junos_version(ansible_adhoc):
    return
