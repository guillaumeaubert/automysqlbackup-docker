#!/bin/bash

export AMB_REMOTE_EXEC="ssh -C $AMB_TARGET"

/app/automysqlbackup 2>&1 \
	| tee /data/automysqlbackup_docker.log \
	| mail -s "AutoMySQLBackup | $AMB_TARGET | `date +'%Y-%m-%d %r %Z'`" root
