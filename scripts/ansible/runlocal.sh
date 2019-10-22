#!/bin/sh

export ANSIBLE_NOCOWS=1

role="$1"
if [ ! -f "$playbook" ]; then
    echo "$0 <role> -vv --step"
    echo "Call to run <role> from roles/ against localhost"
    exit
fi
shift

rolefile="$(dirname "$0")/role.yml"

cat <<EOF > "$rolefile"
---
- name: Run role against localhost
hosts: localhost
tasks:
  - include_role:
      name: $role
EOF

set -x
ansible-playbook -i hosts "$rolefile" "$@"
