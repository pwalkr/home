#!/bin/sh

if [ -z "$1" ]; then
    echo "$0 <password>"
    exit
fi

checksum="$(printf '%s' "$1" | sha1sum | awk '{print $1}')"
prefix="$(printf '%.5s' "$checksum")"
suffix="$(printf "$checksum" | sed 's/^.\{5\}//')"

if [ "$checksum" != "$prefix$suffix" ]; then
    echo "Sanity failure - failed to extract prefix/suffix"
    exit 1
fi

url="https://api.pwnedpasswords.com/range/$prefix"

cat <<EOF
Checking pwned for sha:
$checksum

+ wget $url

EOF

candidates="$(wget "https://api.pwnedpasswords.com/range/$prefix" -O- 2>/dev/null)"

# Lowercase for preference
if echo "$candidates" | tr '[:upper:]' '[:lower:]' | grep "$suffix"; then
    echo 'Pwned!'
else
    echo "No match found."
fi
