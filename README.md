# __pytest__ Container

- [__pytest__ Container](#pytest-container)
  - [__pytest__ Features](#pytest-features)
    - [Packaged pytest plugins](#packaged-pytest-plugins)
      - [Test Fixtures and Styles](#test-fixtures-and-styles)
      - [Reporting](#reporting)
      - [Test Execution](#test-execution)
    - [Packaged python3 modules](#packaged-python3-modules)
  - [__Ansible__ Features](#ansible-features)
  - [__Usage__](#usage)
    - [Mounting Tests and Output](#mounting-tests-and-output)
    - [Forking the Container](#forking-the-container)
    - [Organizing Tests](#organizing-tests)
    - [Development Environment](#development-environment)
    - [__Examples__](#examples)
      - [Setup: Installing a VSRX Topology for Demo purposes](#setup-installing-a-vsrx-topology-for-demo-purposes)
        - [Supported Vagrant Topologies](#supported-vagrant-topologies)
        - [Usage](#usage)
      - [PyEZ Connectivity Testing](#pyez-connectivity-testing)
      - [JSNAPy Audit/Diff](#jsnapy-auditdiff)
      - [Reporting Examples](#reporting-examples)
        - [CSV](#csv)
        - [HTML](#html)
        - [JSON](#json)
        - [Coverage](#coverage)
        - [Test Exectution Time](#test-exectution-time)
        - [Style](#style)
        - [Static Analysis](#static-analysis)
      - [Packaging and Distributing pytest Tests](#packaging-and-distributing-pytest-tests)

Container for executing pytest tests and Ansible roles on network devices, especially (our favorite) Juniper network devices.

The test framework [pytest](https://docs.pytest.org/en/latest/) is a simple yet powerful developer-friendly test framework that unleashes the full power of [Python 3](https://docs.python-guide.org) and [Ansible](https://docs.ansible.com/ansible/latest/network/getting_started/index.html) to automate network validation.


## __pytest__ Features

![pytest](images/pytest-logo.png)

The [pytest test automation framework](https://docs.pytest.org/en/latest/) provides a rich set of capabilities including:

1. Detailed info on failing assert statements (no need to remember self.assert* names);
2. Auto-discovery of test modules and functions;
3. Modular fixtures for managing small or parametrized long-lived test resources;
4. Rich plugin architecture, with over 315+ external plugins and thriving community;

This container packs the plugins and libraries that are well-supported and particularly useful for Network Automation, including:

### Packaged pytest plugins

#### Test Fixtures and Styles

|  module  |  purpose |
|---|---|
| [pytest-ansible](https://github.com/ansible/pytest-ansible/blob/master/README.md)         | Several fixtures for reading [Ansible](https://docs.ansible.com/ansible/latest/network/getting_started/index.html) inventory (including dynamically generated inventory), running [Ansible](https://docs.ansible.com/ansible/latest/network/getting_started/index.html) modules, or inspecting [ansible_facts](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variables-discovered-from-systems-facts).                                 |
| [pytest-ansible-playbook-runner](https://github.com/final-israel/pytest-ansible-playbook-runner/blob/master/README.md)         | Run [Ansible playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) during setup, execution and teardown phases of a test case.  |
| [pytest-bdd](https://github.com/pytest-dev/pytest-bdd/blob/master/README.rst)             | Implements a subset of the Gherkin language to enable automating project requirements testing in natural language.  If you really liked Robot keywords, you'll love this.        |
| [pytest-variables](https://github.com/pytest-dev/pytest-variables/blob/master/README.rst) | Provides variables to tests/fixtures as a dictionary via a file specified on the command line. YAML support provided out of the box.  Use if you want to avoid usage of Ansible. |

#### Reporting

| module                                                                                              | purpose                                                                       |
| --------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| [pytest-csv](https://github.com/nicoulaj/pytest-csv/blob/master/README.rst)                         | CSV output for pytest.                                                        |
| [pytest-html](https://pypi.org/project/pytest-html/1.6/)                                            | Generates a HTML report for the test results.                                 |
| [pytest-json-report](https://github.com/numirias/pytest-json-report)                                | Creates test reports as JSON.                                                 |
| [pytest-cov](https://github.com/pytest-dev/pytest-cov/blob/master/README.rst)                       | Produces coverage reports.                                                    |
| [pytest-pycodestyle](https://github.com/henry0312/pytest-codestyle/blob/master/README.md)           | Style checker for pytest code.                                                |
| [pytest-flakes](https://github.com/fschulze/pytest-flakes/blob/master/README.rst)                   | Static analyzer for pytest code  to check for coding bugs prior to execution. |
| [pytest-excel](https://github.com/ssrikanta/pytest-excel/blob/master/README.rst)                         | Excel output for pytest.                                                        |

#### Test Execution

| module                                                                                        | purpose                                                          |
| --------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| [pytest-atomic](https://github.com/megachweng/pytest-atomic/blob/master/README.md)            | Skip rest of tests if previous test failed.                      |
| [pytest-xdist](https://github.com/pytest-dev/pytest-xdist/blob/master/README.rst)             | A pytest distributed testing plugin for parallel test execution. |
| [pytest-shutil](https://github.com/manahl/pytest-plugins/blob/master/pytest-shutil/README.md) | A set of useful shell utiltity commands and settings.            |

### Packaged python3 modules

|module|purpose|
|---|---|
|[ansible](https://docs.ansible.com/ansible/latest/network/getting_started/index.html)|Extensible framework for automated configuration of network-connected devices and systems.  Inventory and playbooks are fully expose to pytest code via the [pytest-ansible](https://github.com/ansible/pytest-ansible/blob/master/README.md) plugin.|
|[junos-eznc](https://github.com/Juniper/py-junos-eznc/blob/master/README.md)|Junos PyEZ is a Python library to remotely manage/automate Junos devices.|
|[jsnapy](https://github.com/Juniper/jsnapy/blob/master/README.md)|Junos Snapshot Administrator enables you to capture and audit runtime environment snapshots of your networked devices running the Junos operating system (Junos OS).|
|[napalm](https://github.com/napalm-automation/napalm/blob/develop/README.md)|NAPALM (Network Automation and Programmability Abstraction Layer with Multivendor support) is a Python library that implements a set of functions to interact with different router vendor devices using a unified API.|
|[napalm-ansible](https://github.com/napalm-automation/napalm-ansible/blob/develop/README.md)|Collection of ansible modules that use napalm to retrieve data or modify configuration on networking devices.  Especially useful for non-Juniper devices.|
|[pexpect](https://pexpect.readthedocs.io/en/stable/)|If you must screen-scrape to remote control an old network device (or enable netconf on a non-Juniper device), this may be a lifesaver.|
|[ixnetwork-restpy](https://www.openixia.com/tutorials?subject=ixNetwork/restApi&page=restPy.html)|A complete REST API to programatically control [IXIA traffic generators](https://www.ixiacom.com/products/test).  Full local documentation is available in [.venv/lib/python3.7/site-packages/ixnetwork_restpy/docs/index.html](.venv/lib/python3.7/site-packages/ixnetwork_restpy/docs/index.html) if you run ```make .venv```|
|[stcrestclient](https://github.com/Spirent/py-stcrestclient/blob/master/README.md)|STC Rest API client to control [Spirent traffic generators](https://www.spirent.com/products-for/high-speed-network-testing).|
|[sshtunnel](https://github.com/pahaz/sshtunnel/blob/master/README.rst)|Library to simplify connectivity to remote services via ssh tunneling.|

## __Ansible__ Features

![Ansible](images/ansible-logo.png)

Ansible is a staple in network automation.  Many customers already have their [inventory in an Ansible-friendly yaml or ini](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) format.  For customers that haven't, we recommend that we steer our customers in this direction.  It's easy enough to [generate an inventory dynamically via a script](https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html) as well from a database or any other static format.  Once this information is available as an Ansible inventory, it can be leveraged in *any* Ansible script or pytest network validation.

The standard [Ansible distribution comes standard with modules to manage network devices](https://docs.ansible.com/ansible/latest/modules/list_of_network_modules.html) from many major network equipment providers, including, most-importantly [Junos devices](https://docs.ansible.com/ansible/latest/modules/list_of_network_modules.html#junos).

## __Usage__

This container can be used two basic ways:

1. Mounting one or two volumes, one for tests and another for test results.
2. Fork this repo.  Your tests should go into a tests directory.  A volume should be mounted to place the test results.  This allows you to add new python modules.  These python modules may contain standard test suites that are added to the test container.

### Mounting Tests and Output

Mount the tests you want to execute if you want to use a pre-built container and you're sure the pre-built container provides all necessary dependencies.  All python code named ```test_*``` will be scanned for tests.  

Any argument can be supplied via ```pytest.ini``` or as arguments to the ```docker run``` command.

If you want to be sure that your container has all the dependencies required to execute at build time

1. The container can be used as-is by mounting test could (files names ```test_*```) into /tests in the container.  Any argument can be supplied via ```pytest.ini``` or as arguments to the ```docker run``` command.
2. In the ```pytest.ini``` packaged with your tests, you can specify all options, including the expected test output directory.  By convention, this can be in a directory named 

### Forking the Container

### Organizing Tests

Note that it's also possible to organize tests in python modules that can be packaged and imported as dependencies from an (internal) pypi repo.

### Development Environment

You must have the following:

1. bash
2. docker
3. make
4. Python 3.6 or better

To set up your development environment, simply run ```make test```.

If you wish to try running py.test interactively on the command line, you'll need to do the following _additional_ steps:

1. ```export PIPENV_VENV_IN_PROJECT=1```
2. ```export PIPENV_VERBOSITY=-1```
3. ```export ANSIBLE_PYTHON_INTERPRETER=python3```

The ```export``` lines can be added to your profile (e.g.-- ```~/.bash_profile```), so you never have to set them again.

Tests should be run from the pipenv shell.  You can do this as follows (If you look at the ```Makefile``` target ```test```, it essentially does the same thing):

1. ```pipenv shell```
2. ```cd tests```
3. ```py.test```

### __Examples__

#### Setup: Installing a VSRX Topology for Demo purposes

For this demo, you will need to have the following additional software installed on your computer:

1. VirtualBox
2. Vagrant

The [vqfx10k-vagrant](https://github.com/Juniper/vqfx10k-vagrant.git) repo is included as a subtree in the ```examples/vqfx10k-vagrant``` directory.  Make targets have been added for each of the topologies to assist you with test development.

##### Supported Vagrant Topologies

|Name|Purpose|Packet Forwarding Engine (PFE)|Ansible Provisioning|RAM|CPU|
|---|---|---|---|---|---|
|[light-1qfx](https://github.com/Juniper/vqfx10k-vagrant/blob/master/light-1qfx/README.md)|Single vqfx.|no|no|1G|1|
|[light-2qfx](https://github.com/Juniper/vqfx10k-vagrant/blob/master/light-2qfx/README.md)|Two vqfx connected back-to-back.|no|yes|2G|2|
|[light-2qfx-2srv](https://github.com/Juniper/vqfx10k-vagrant/blob/master/light-2qfx-2srv/README.md)|Two vqfx connected back-to-back each with one ubuntu server attached.|no|yes|3G|1|
|[light-ipfabric-2S-3L](https://github.com/Juniper/vqfx10k-vagrant/blob/master/light-ipfabric-2S-3L/README.md)|Spine and leaf topology with two spines, three leaves, and an ubuntu server attached to each leaf.|no|yes|7G|2|
|[full-1qfx](https://github.com/Juniper/vqfx10k-vagrant/blob/master/full-1qfx/README.md)|Single vqfx.|yes|no|3G|2|
|[full-2qfx](https://github.com/Juniper/vqfx10k-vagrant/blob/master/full-2qfx/README.md)|Two vqfx connected back-to-back|yes|yes|5G|3|
|[full-4qfx](https://github.com/Juniper/vqfx10k-vagrant/blob/master/full-4qfx/README.md)|Four vqfx connected in a full-mesh.|yes|yes|10G|5|
|[full-1qfx-1srv](https://github.com/Juniper/vqfx10k-vagrant/blob/master/full-1qfx-1srv/README.md)|Single vqfx with an ubuntu server attached.|yes|yes|3G|2|
|[full-2qfx-4srv-evpnvxlan](https://github.com/Juniper/vqfx10k-vagrant/blob/master/full-2qfx-4srv-evpnvxlan/README.md)|Two vqfx, attached back-to-back, each with two ubuntu servers attached.|yes|yes|8G|3|
|[full-ipfabric-2S-3L](https://github.com/Juniper/vqfx10k-vagrant/blob/master/full-ipfabric-2S-3L/README.md)|Spine and leaf topology with two spines, three leaves, and an ubuntu server attached to each leaf.|yes|yes|16G|4|

For more information on the supported topologies, click the link in the _Name_ column above.

##### Usage

Each topology has three make target actions: ```up```,```down``` and ```destroy```.  To form the target name simple prepend the target action to the topology name.  

__To bring up and provision the topology ```light-2qfx```, simply run:__

``` bash
make up-light-2qfx
```

If the topology support Ansible provisioning, then a provisioning script is run after the system(s) come up.  The inventory file can be found in topology directory, under ```.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory```.  It's in ```ini``` format.  This can be used for subsequent Ansible playbooks, and as inventory for ```pytest```.

To stop (but not destroy) it:

``` bash
make halt-light-2qfx
```

To destroy it:

``` bash
make destroy-light-2qfx
```

#### PyEZ Connectivity Testing

#### JSNAPy Audit/Diff

#### Reporting Examples

##### CSV

``` bash
$ pipenv run py.test --csv=report.csv
...
$ cat report.csv
id,module,name,file,doc,markers,status,message,duration
examples/test_2qfx.py::test_get_inventory,examples.test_2qfx,test_get_inventory,examples/test_2qfx.py,,,passed,,0.11594510078430176
examples/test_2qfx.py::test_junos_alarms,examples.test_2qfx,test_junos_alarms,examples/test_2qfx.py,,,passed,,1.038262128829956
examples/test_2qfx.py::test_interfaces_up,examples.test_2qfx,test_interfaces_up,examples/test_2qfx.py,,,passed,,0.4928560256958008
examples/test_2qfx.py::test_junos_version,examples.test_2qfx,test_junos_version,examples/test_2qfx.py,,,passed,,0.0002608299255371094
```

##### HTML

By default, the style.css is generated into an ```assets``` folder in the same directory as the HTML report.  If you don't like that, use the ```--self-contained-html``` flag.

``` bash
$ pipenv run py.test --html=report.html  --self-contained--html
```
![pytest HTML report](images/report-html.png)

##### JSON

The JSON report will dump out a JSON data blob that contain the results of all individual tests and what was logged.

``` bash
$ pipenv run py.test --json-report --json-report-file=report.json
...
$ jq .summary report.json
{
  "passed": 4,
  "total": 4
}
```

There is also a ```--json-report-summary``` option to only indicate if the entire suite passed.

##### Coverage

There are a variety of code coverage options.  Just specify a path to report code coverage on, and a report type.

``` bash
$ pipenv run py.test --cov=examples --cov-report=term --cov-branch
...
---------- coverage: platform darwin, python 3.7.4-final-0 -----------
Name                    Stmts   Miss Branch BrPart  Cover
---------------------------------------------------------
examples/test_2qfx.py      37      0      2      0   100%
```

##### Test Exectution Time

Use the ```---durations=0``` flag to make pytest report all test durations.  You can pass it a number to say the minimum slowest test you want the duration to be reported for.

``` bash
$ pipenv run py.test --durations=0
...
========================================= slowest test durations =========================================
1.00s call     examples/test_2qfx.py::test_junos_alarms
0.48s call     examples/test_2qfx.py::test_interfaces_up
0.16s call     examples/test_2qfx.py::test_get_inventory

(0.00 durations hidden.  Use -vv to show these durations.)
======================================== 4 passed in 2.05 seconds ========================================
```

##### Style

It's highly recommended that you validate your code style during test execution to avoid errors.

``` bash
$ pipenv run py.test --codestyle
============================================= test session starts ==============================================
platform darwin -- Python 3.7.4, pytest-5.0.1, py-1.8.0, pluggy-0.12.0
ansible: 2.8.2
rootdir: /Users/ejacques/projects/Foundational/pytest, inifile: pytest.ini, testpaths: examples
plugins: bdd-3.1.1, xdist-1.29.0, forked-1.0.2, flakes-4.0.0, csv-2.0.2, atomic-2.0.0, shutil-1.7.0, ansible-2.1.1, variables-1.7.1, ansible-playbook-runner-0.0.2, pycodestyle-1.4.0, cov-2.7.1, html-1.21.1, profiling-1.7.0, json-report-1.1.0, metadata-1.8.0
collected 5 items                                                                                              

examples/test_2qfx.py FAILED                                                                             [ 20%]
examples/test_2qfx.py::test_get_inventory PASSED                                                         [ 40%]
examples/test_2qfx.py::test_junos_alarms PASSED                                                          [ 60%]
examples/test_2qfx.py::test_interfaces_up PASSED                                                         [ 80%]
examples/test_2qfx.py::test_junos_version PASSED                                                         [100%]

=================================================== FAILURES ===================================================
______________________________________________ pycodestyle-check _______________________________________________
/Users/ejacques/projects/Foundational/pytest/examples/test_2qfx.py:13:80: E501 line too long (113 > 79 characters)
            ["ansible_host", "ansible_port", "ansible_user", "ansible_password", "ansible_ssh_private_key_file"]}
                                                                               ^
/Users/ejacques/projects/Foundational/pytest/examples/test_2qfx.py:57:80: E501 line too long (100 > 79 characters)
        assert(len(chassis_alarms.xpath('//alarm-information/alarm-summary/no-active-alarms')) == 1)
                                                                               ^
/Users/ejacques/projects/Foundational/pytest/examples/test_2qfx.py:61:80: E501 line too long (99 > 79 characters)
        assert(len(system_alarms.xpath('//alarm-information/alarm-summary/no-active-alarms')) == 1)
                                                                               ^

====================================== 1 failed, 4 passed in 1.87 seconds ======================================
```

##### Static Analysis

Static analysis can also be run to check for potentially problematic code:

``` bash
$ pipenv run py.test --flakes
============================================= test session starts =============================================
platform darwin -- Python 3.7.4, pytest-5.0.1, py-1.8.0, pluggy-0.12.0
ansible: 2.8.2
rootdir: /Users/ejacques/projects/Foundational/pytest, inifile: pytest.ini, testpaths: examples
plugins: bdd-3.1.1, xdist-1.29.0, forked-1.0.2, flakes-4.0.0, csv-2.0.2, atomic-2.0.0, shutil-1.7.0, ansible-2.1.1, variables-1.7.1, ansible-playbook-runner-0.0.2, pycodestyle-1.4.0, cov-2.7.1, html-1.21.1, profiling-1.7.0, json-report-1.1.0, metadata-1.8.0
collected 5 items                                                                                             

examples/test_2qfx.py FAILED                                                                            [ 20%]
examples/test_2qfx.py::test_get_inventory PASSED                                                        [ 40%]
examples/test_2qfx.py::test_junos_alarms PASSED                                                         [ 60%]
examples/test_2qfx.py::test_interfaces_up PASSED                                                        [ 80%]
examples/test_2qfx.py::test_junos_version PASSED                                                        [100%]

================================================== FAILURES ===================================================
_______________________________________________ pyflakes-check ________________________________________________
/Users/ejacques/projects/Foundational/pytest/examples/test_2qfx.py:70: UnusedVariable
local variable 'vqfx1' is assigned to but never used
/Users/ejacques/projects/Foundational/pytest/examples/test_2qfx.py:73: UnusedVariable
local variable 'vqfx2' is assigned to but never used
===================================== 1 failed, 4 passed in 1.90 seconds ======================================
```

#### Packaging and Distributing pytest Tests

Since the test suite is just Python code, you can simply package up tests or common test utilities as a Python module.  For that purpose, the [cookiecutter](https://cookiecutter.readthedocs.io/en/latest/tutorial1.html#step-1-generate-a-python-package-project) project is available to easily generate a Python Package project.
