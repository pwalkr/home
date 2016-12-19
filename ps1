#!/bin/sh

last_command="$1"
last_command_code="$2"

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
DASH="$(printf "%b" "\xe2\x94\x80")"

ACCENT="$CYAN"

PROMPT="$ACCENT"

user="$(whoami)"
PROMPT+="$DASH( $user@$(hostname) )$DASH"

PROMPT+="$DASH( $(date +%H:%M:%S) )$DASH"


if which acpi &>/dev/null; then
	acpi_b="$(acpi --battery)"
	battery="$(echo "$acpi_b" | grep -o "[0-9]\+%")"
	if [ "$battery" == "100%" ]; then
		battery="${GREEN}${battery}${ACCENT}"
	elif echo "$acpi_b" | grep --ignore-case --quiet discharging; then
		battery="${RED}-${battery}${ACCENT}"
	else
		battery="${GREEN}+${battery}${ACCENT}"
	fi
	PROMPT+="$DASH( $battery )$DASH"
fi

ghash="$(git rev-parse HEAD 2>/dev/null)"
if [ "$ghash" ]; then
	PROMPT+="$DASH( "

	if [ "$(git diff --cached --name-only 2>/dev/null)" ]; then
		PROMPT+="$YELLOW"
	elif [ "$(git diff --name-only 2>/dev/null)" ]; then
		PROMPT+="$RED"
	else
		PROMPT+="$GREEN"
	fi

	# Ahead, behind or out of sync with upstream
	upstream="$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)"
	if [ "$upstream" ]; then
		uhash="$(git rev-parse $upstream)"
		if [ "$ghash" != "$uhash" ]; then
			if [ "$(git rev-list HEAD | grep $uhash)" ]; then
				PROMPT+="+"
			elif [ "$(git rev-list $upstream | grep $ghash)" ]; then
				PROMPT+="-"
			else
				PROMPT+="~"
			fi
		fi
	fi

	branch="$(git symbolic-ref --short HEAD 2>/dev/null)"
	if [ "$branch" ]; then
		PROMPT+="$branch"
	else
		PROMPT+="${ghash:0:7}"
	fi

	# New un-tracked files
	if [ "$(git ls-files --other --exclude-standard 2>/dev/null)" ]; then
		PROMPT+="*"
	fi

	PROMPT+="$ACCENT )$DASH"
fi

length_printable="$(tr -dc '[[:print:]]' <<< "$PROMPT")"
length_printable=${#length_printable}
cols=$(tput cols)
length_truncated=$((cols - length_printable - 6))
if [ "${#last_command}" -gt  "$length_truncated" ]; then
	index_left="$((length_truncated / 2))"
	index_right="$((${#last_command} - index_left + 1))"
	index_left="$((index_left - 2))"
	last_command="${last_command:0:index_left}...${last_command:index_right}"
fi
PROMPT+="$DASH( $last_command )$DASH"

PROMPT+="\n"

path="$(pwd)"
if [ "${#path}" -gt 20 ]; then
	pl=${#path}
	pi=$((pl-23))
	path="...${path:pi}"
fi
PROMPT+="($path)"

if [ "$last_command_code" = "0" ]; then
	PROMPT+="$GREEN"
else
	PROMPT+="$RED"
fi
if [ "$user" = "root" ]; then
	PROMPT+="#"
else
	PROMPT+="$"
fi
PROMPT+="$WHITE"

printf "%b " "$PROMPT"
