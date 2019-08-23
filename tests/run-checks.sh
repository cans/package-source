#!/bin/bash
###
# Small script to run most basic checks locally.
###
basedir="$(cd `dirname ${0}`; pwd)"
cd "${basedir}"
set -o pipefail

cat > ansible.cfg <<HERE
[defaults]
roles_path = ../../
HERE
ansible-playbook packages-both-present-and-absent.yml local.yml --syntax-check | tee "${TEST_REPORTS_DIR:-.}/ansible-syntax-check.log"
ansible-lint --force-color packages-both-present-and-absent.yml local.yml 2>&1 | tee "${TEST_REPORTS_DIR:-.}/ansible-lint.log" || true

rm ./ansible.cfg

