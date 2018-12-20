#
# This script sends details of the latest Backup to Zabbix

# Send Exit Code
zabbix_sender -v --config /etc/zabbix/zabbix_agentd.conf --key "restic.backup.exitcode" --value "$?"

# Send Bytes Added to the Repo
LOG_ADDED=$( cat /var/log/restic/latest-backup.log | \
			 grep 'Added to the repo' | awk '{print $5,$6}' | \
			 python3 -c 'import sys; import humanfriendly; print (humanfriendly.parse_size(sys.stdin.read(), binary=True))' )
zabbix_sender --config /etc/zabbix/zabbix_agentd.conf --key "restic.backup.added" --value "$LOG_ADDED"

# Send Snapshot ID
LOG_SNAPSHOT=$( grep 'snapshot' /var/log/restic/latest-backup.log | awk '{print $2}')
zabbix_sender --config /etc/zabbix/zabbix_agentd.conf --key "restic.backup.snapshotid" --value "$LOG_SNAPSHOT"

# Send Execution Time in Seconds
LOG_DURATION=$( grep 'processed' /var/log/restic/latest-backup.log | \
				awk '{print $NF}' | \
				awk -F':' '{print (NF>2 ? $(NF-2)*3600 : 0) + (NF>1 ? $(NF-1)*60 : 0) + $(NF)}' )
zabbix_sender --config /etc/zabbix/zabbix_agentd.conf --key "restic.backup.duration" --value "$LOG_DURATION"