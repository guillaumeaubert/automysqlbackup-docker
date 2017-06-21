#!/bin/sh

set -e

# Adjust timezone.
cp /usr/share/zoneinfo/${AMB_TIMEZONE} /etc/localtime
echo ${AMB_TIMEZONE} > /etc/timezone
echo "Date: `date`."

# Set up automysqlbackup group.
: ${AMB_GID:="$AMB_DEFAULT_GID"}
if [ "$(id -g amb)" != "$AMB_GID" ]; then
	groupmod -o -g "$AMB_GID" amb
fi
echo "Using group ID $(id -g amb)."

# Set up automysqlbackup user.
: ${AMB_UID:="$AMB_DEFAULT_UID"}
if [ "$(id -u amb)" != "$AMB_UID" ]; then
	usermod -o -u "$AMB_UID" amb
fi
echo "Using user ID $(id -u amb)."

# Make sure the files are owned by the user executing automysqlbackup, as we
# will need to add/delete files.
chown -R amb:amb /data

# Fix ssh permissions if .ssh is mounted.
if [ -d /home/amb/.ssh ]; then
	chown amb:amb -R /home/amb/.ssh
	chmod 700 /home/amb/.ssh
	chmod 600 /home/amb/.ssh/*
fi

# Set up crontab.
echo "" > $CRONTAB
echo "${AMB_SCHEDULE} /app/automysqlbackup_wrapper.sh" >> $CRONTAB

# Start app.
if [ "$AMB_RUN_ON_STARTUP" == "yes" ]; then
	su-exec amb "/app/automysqlbackup_wrapper.sh"
fi

echo "Starting cron."
exec crond -l 8 -f
