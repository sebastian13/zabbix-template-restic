# This sends restic check response to Zabbix
#

# Send Exit Code
zabbix_sender -v --config /etc/zabbix/zabbix_agentd.conf --key "restic.check.exitcode" --value "$?"

# Send detailed result message
LOG_CHECK=$( tail -1 /var/log/restic/latest-check.log )
zabbix_sender --config /etc/zabbix/zabbix_agentd.conf \
	--key "restic.check.message" --value "$LOG_CHECK"