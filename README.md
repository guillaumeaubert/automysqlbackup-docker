Docker Image for AutoMySQLBackup
================================


Code Status
-----------

[![Docker Pulls](https://img.shields.io/docker/pulls/aubertg/automysqlbackup-docker.svg)](https://hub.docker.com/r/aubertg/automysqlbackup-docker/)


Overview
--------

A Docker image that runs AutoMySQLBackup on a regular basis and emails out
reports through ssmtp.

```
docker run \
	-v "backup_directory:/data" \
	-v "automysqlbackup.conf:/etc/automysqlbackup/automysqlbackup.conf:ro" \
	-v "ssh:/home/amb/.ssh" \
	-v "ssmtp.conf:/etc/ssmtp/ssmtp.conf" \
	-e AMB_SCHEDULE="10 3,15 * * *" \
	-e AMB_TARGET="$REMOTE_HOST" \
	-e AMB_RUN_ON_STARTUP="no" \
	-t \
	-d \
	aubertg/automysqlbackup-docker
```


Running this container for the first time
-----------------------------------------


1. Set up a ssh directory on the host (similar to a normal `~/.ssh/` for a
user) and mount it as a Docker volume at `/home/amb/.ssh`. Make sure the
container has read/write access to it (no `:ro` at the end of the volume
declaration above).

2. Start the container.

3. Attach a terminal to your container.

4. Run these commands:  
```
su amb
ssh $AMB_TARGET
```

5. Accept the authenticity of the host if you are connecting for the first
time, and make sure that you successfully get a shell on the remote server.

6. Close the shell.

7. Restart the container if you have set `AMB_RUN_ON_STARTUP="yes" and would
like to start the first run of AutoMySQLBackup immediately.


Volumes
-------

The container requires the following volumes to be attached in order to work
properly:

* **`/data`** *(mandatory)*  
	Where the AutoMySQLBackup backup files and logs will be stored.

* **`/etc/ssmtp/ssmtp.conf`** *(mandatory)*  
	A ssmtp config file to send emails reports from the Docker container.

	Example for Gmail:
	```
	# Settings for Gmail SMTP service.
	mailhub=smtp.gmail.com:587
	hostname=smtp.gmail.com:587
	UseSTARTTLS=YES
	FromLineOverride=YES

	# Gmail account.
	root=mygmailaddress@gmail.com
	AuthUser=mygmailaddress@gmail.com
	AuthPass=mypassword
	```

* **`/etc/automysqlbackup/automysqlbackup.conf`** *(mandatory)*  
	A configuration file for AutoMySQLBackup. See `automysqlbackup_default.conf`
	in the git repository of this image for an example of configuration file
	corresponding to the version of AutoMySQLBackup shipping with this Docker
	image.

* **`/home/amb/.ssh`** *(optional)*  
	A persistent ssh directory with files such as `config` and a private key that
	allows connecting to the remote host.


Environment Variables
---------------------

The container is configurable through the following environment variables:

* **`AMB_UID`** *(optional)*  
	Numeric uid in the host that should own created files; defaults to 9000.

* **`AMB_GID`** *(optional)*  
	Numeric gid in the host that should own created files; defaults to 9000.

* **`AMB_TIMEZONE`** *(optional)*  
	Timezone; defaults to America/Los_Angeles.

* **`AMB_SCHEDULE`** *(optional)*  
	Custom sync schedule; defaults to daily at 1:00am.

* **`AMB_RUN_ON_STARTUP`** *(optional)*  
	Set to `yes` to trigger a run when the container starts, in addition to the
	normal cron schedule.


Copyright
---------

Copyright (C) 2017 Guillaume Aubert.


License
-------

* The original version of AutoMySQLBackup (v3.0_rc6) is under the GPLv2
license. The modifications to `automysqlbackup` in this repository and
corresponding Docker image are accordingly released under the GPLv2 license.

* This software is released under the GPLv2 license. See the LICENSE file for
details.


Disclaimer
----------

I am providing code in this repository to you under an open source license.
Because this is my personal repository, the license you receive to my code is
from me and not from my employer (Facebook).
