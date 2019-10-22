#!/bin/sh

# Created playbook
playbook="$(dirname "$0")/role.yml"

roles="$(dirname "$0")/roles"

export ANSIBLE_NOCOWS=1

role="$1"
if [ ! -d "$roles/$role" ]; then
    echo "$0 <role> -vv --step"
    echo
    echo "Call to run <role> from roles/ against localhost. Select from:"
    ls "$roles" | fold -w 76 -s | sed 's/^/    /'
    exit
fi
shift


cat <<EOF > "$playbook"
---
- name: Run role against localhost
  hosts: localhost
  gather_facts: false
  tasks:
    - include_role:
        name: $role
EOF

set -x
ansible-playbook "$playbook" "$@"
rm "$playbook"
