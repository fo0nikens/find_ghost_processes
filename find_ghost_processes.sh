#!/bin/bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Name:        find_ghost_processes
# Type:        Bash shell script
# Author:      princebot
# Creation:    2014-09-28T14:35-05:00
# Usage:       find_ghost_processes [no options, no args]
# Description: Finds all currently running processes whose source files have
#              been deleted, saves a copy of any deleted sources files, and
#              reports the results.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


print_divider() { for i in $(seq 79); do echo -n "="; done && echo ;}

TIMESTAMP1="$(date +%Y-%m-%d)"
TIMESTAMP2="$(date +%Y%m%dT%H%M%S)"
PDIR="/root/ghost_processes"
CDIR="${PDIR}/${TIMESTAMP1}"
GCDIR="${CDIR}/${TIMESTAMP2}"
OUTFILE="${GCDIR}/${TIMESTAMP2}_report"

mkdir -p "${PDIR}" "${CDIR}" "${GCDIR}"
echo -e "List of running processes with deleted source files" > "${OUTFILE}"
echo -e "$(date)\n" >> "${OUTFILE}"

for pid in $(ps -ef | awk 'NR != 1 {print $2}'); do
    pid_dir="/proc/${pid}/fd"
    ls -l "${pid_dir}" 2> /dev/null | grep deleted &> /dev/null
    if [[ $? == 0 ]]; then
        fname="$(ls -l "${pid_dir}" | sed -nr 's/.* ([0-9]+).*deleted.*/\1/p')"
        fcopy="${GCDIR}/${pid}_source"
        cat "${pid_dir}/${fname}" > "${fcopy}"
        echo -e "PID:\t\t${pid}\nSource copy:\t${fcopy}\n" >> "${OUTFILE}"
    fi
done

msg="Contents of results file ${fcopy}:"
let "padding = (79 - ${#msg}) / 2"
echo && print_divider
printf "%${padding}s${msg}\n"
print_divider
echo -e "\n$(cat "${OUTFILE}")\n"
