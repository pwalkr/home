#!/bin/bash

echo `acpi -b | awk -F "(: |,)" '{ print $2$3$4 }'`

exit 0

