#!/bin/bash

# Find all usernames in svn history and create a git-user template

echo "svn log -q | awk -F '|' '/^r/ {sub(\"^ \", \"\", \$2); sub(\" $\", \"\", \$2); print \$2\" = \"\$2\" <\"\$2\">\"}' | sort -u > authors-transform.txt"
