#!/bin/bash

readonly states=("Charging" "Full")

readonly exit_power=0
readonly exit_battery=1
readonly exit_unknown=-1

exit_default=$exit_power

which acpi 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
	echo "Acpi not found, please install it first!"
	exit $exit_default
fi

exit_multiple=$exit_unknown
# Multiple batteries
IFS='\n'
for battery in $(acpi); do
	echo "$battery"
	battery_id=$(echo $battery | awk '{print $2}')
	state_plain=$(echo $battery | awk '{print $3}')
	echo "state_plain: $state_plain"

	if [[ "$state_plain" =~ ^([a-zA-Z]+),$ ]]; then 
		state="${BASH_REMATCH[1]}"
	else 
		echo "Not propper format of acpi!"
		continue
	fi

	echo ${states[*]} | grep -q $state 1>/dev/null 2>/dev/null
	if [ $? -eq 0 ]; then
		echo "On power"
		exit_multiple=$exit_power
	else
		echo "On battery"
		if [ $exit_multiple -eq $exit_unknown ]; then
			exit_multiple=$exit_battery
		fi
	fi
done

if [ $exit_multiple -eq $exit_unknown ]; then
	exit $exit_default
fi

exit $exit_multiple
