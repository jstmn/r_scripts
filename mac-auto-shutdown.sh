#!/bin/bash

echo $(date)

DAY=$(date +%u)
HOUR=$(date +%H)

# 11pm-12am
if [ $DAY -lt 5 ]; then
	echo "is currently m, t, w, or th"
	if [ $HOUR -gt 22 ]; then
		echo "is currently past 11, turning computer off"
		say "turning computer off in 5 seconds"
		sleep 5
		osascript -e 'tell app "System Events" to shut down'
	fi
fi

# 12am - 2am
if [ $DAY -lt 6 ]; then
	if [ $HOUR -lt 3 ]; then
		echo "is currently past 12, turning computer off"
		say "turning computer off in 5 seconds"
		sleep 5
		osascript -e 'tell app "System Events" to shut down'
	fi
fi


# crontab item:
# */5 * * * * bash /Users/admin/Documents/auto-shutdown.sh > /Users/admin/Documents/auto-shutdown-output.txt
