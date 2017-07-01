#!/bin/bash

PROVISIONING_HOME=$(cd $(dirname ${BASH_SOURCE:-$0})/../ && pwd)

cd ${PROVISIONING_HOME}/provisioning > /dev/null 2>&1
ansible-playbook files.yml
