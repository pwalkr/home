#!/bin/sh

# Call this in your PS1 prompt variable via: (~/.bashrc)
# PS1='$(s=$?; h="$(history 1)"; $HOME/.ps1 "${h:7}" "$s")'

LAST_COMMAND="$1"
LAST_COMMAND_CODE="$2"

PROMPT=

# Longer than a hyphen, provides continuous horizontal line
#DASH="$(echo -e "\xe2\x94\x80")"
DASH="-"

RED='\001\033[31m\002'
GREEN='\001\033[32m\002'
YELLOW='\001\033[33m\002'
CYAN='\001\033[36m\002'

CLEAR='\001\033[0m\002'
BOLD='\001\033[1m\002'

ACCENT="$CYAN"
if [ "$USER" = root ]; then
	ACCENT="$RED"
fi

append_userhost() {
	if [ -z "$SSH_CLIENT" -a -z "$SSH_TTY" ]; then
		PROMPT="$PROMPT$DASH( $USER@$(hostname) )$DASH"
	else
		PROMPT="$PROMPT$DASH( $USER@$YELLOW$(hostname)$ACCENT )$DASH"
	fi
}
append_timestamp() {
	PROMPT="$PROMPT$DASH( $(date +%H:%M:%S) )$DASH"
}
append_battery(){
	local acpi_b=
	local percent=
	if ! which acpi >/dev/null 2>&1; then
		return
	fi
	PROMPT="$PROMPT$DASH("
	acpi_b="$(acpi --battery | head -1)"
	percent="$(echo "$acpi_b" | grep -o "[0-9]\+%")"
	if [ "$percent" = "100%" ]; then
		PROMPT="$PROMPT$GREEN $percent "
	elif echo "$acpi_b" | grep --ignore-case --quiet discharging; then
		PROMPT="$PROMPT$RED -$percent "
	else
		PROMPT="$PROMPT$GREEN +$percent "
	fi
	PROMPT="$PROMPT$ACCENT)$DASH"
}
append_git() {
	local ghash=
	local upstream=
	local uhash=
	local branch=
	if ! which git >/dev/null 2>&1; then
		return
	fi
	ghash="$(git rev-parse HEAD 2>/dev/null)"
	if [ "$ghash" ]; then
		PROMPT="$PROMPT$DASH("

		if [ "$(git diff --cached --name-only 2>/dev/null)" ]; then
			PROMPT="$PROMPT$YELLOW "
		elif [ "$(git diff --name-only 2>/dev/null)" ]; then
			PROMPT="$PROMPT$RED "
		else
			PROMPT="$PROMPT$GREEN "
		fi

		# Ahead, behind or out of sync with upstream
		upstream="$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)"
		if [ "$upstream" ]; then
			uhash="$(git rev-parse $upstream 2>/dev/null)"
			if [ "$uhash" = "@{u}" ]; then
				# remote-tracking branch has been removed
				PROMPT="$PROMPT!"
			elif [ "$ghash" != "$uhash" ]; then
				if git rev-list HEAD 2>/dev/null | grep --quiet --max-count=1 $uhash; then
					PROMPT="$PROMPT+"
				elif git rev-list $upstream 2>/dev/null | grep --quiet --max-count=1 $ghash; then
					PROMPT="$PROMPT-"
				else
					PROMPT="$PROMPT~"
				fi
			fi
		fi

		branch="$(git symbolic-ref --short HEAD 2>/dev/null)"
		if [ "$branch" ]; then
			PROMPT="$PROMPT$branch"
		else
			branch="$(git tag --points-at HEAD | tail -1)"
			if [ "$branch" ]; then
				PROMPT="$PROMPT<$branch>"
			else
				PROMPT="$PROMPT${ghash:0:7}"
			fi
		fi

		# New un-tracked files
		if git status --porcelain 2>/dev/null | grep --quiet "^?? "; then
			PROMPT="$PROMPT*"
		fi

		PROMPT="$PROMPT$ACCENT )$DASH"
	fi
}
append_command() {
	local cols=$(tput cols)
	local index_left=
	local index_right=
	local last_command="$LAST_COMMAND"
	#local length_printable="$(echo -e "$PROMPT" | tr -dc '[[:print:]]')"
	#echo -e "$PROMPT" | tr -dc '\40-\176'
	#echo "$PROMPT" | sed 's/\\001.\{,10\}\\002//g'
	# Strip out anything between \[ and \] (\001 and \002)
	local length_printable="$(echo "$PROMPT" | sed 's/\\001.\{,10\}\\002//g')"
	length_printable=${#length_printable}
	local length_truncated=$((cols - length_printable - 6))
	if [ "${#LAST_COMMAND}" -gt  "$length_truncated" ]; then
		index_left="$((length_truncated / 2))"
		index_right="$((${#LAST_COMMAND} - index_left + 1))"
		index_left="$((index_left - 2))"
		last_command="${LAST_COMMAND:0:index_left}...${LAST_COMMAND:index_right}"
	fi
	PROMPT="$PROMPT$DASH( $last_command )$DASH"
}
append_path() {
	local path="$(pwd)"
	local pl=
	local pi=
	if [ "${#path}" -gt 20 ]; then
		pl=${#path}
		pi=$((pl-17))
		path="...${path:pi}"
	fi
	PROMPT="$PROMPT($path)"
}

PROMPT="\n$BOLD$ACCENT"
append_userhost
append_timestamp
append_battery
append_git
append_command
PROMPT="$PROMPT\n"
append_path


if [ "$LAST_COMMAND_CODE" = "0" ]; then
	PROMPT="$PROMPT$BOLD$GREEN"
else
	PROMPT="$PROMPT$BOLD$RED"
fi
if [ "$USER" = "root" ]; then
	PROMPT="$PROMPT#"
else
	PROMPT="$PROMPT$"
fi

printf "%b%b " "$PROMPT" "$CLEAR"
