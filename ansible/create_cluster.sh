#!/bin/bash

inventory=${INVENTORY:-inventory}
ansible-playbook -i ${inventory} k8s.yml $@

