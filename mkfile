all:V: $hosts

%: /n/%/etc
	dircp `{pwd} /n/$stem/etc/conf

/n/%/etc:	
	if(test -f /srv/ssh.$stem)
		exec mount -c /srv/ssh.$stem /n/$stem
	exec sshfs -r / -s ssh.$stem -m /n/$stem root@$stem
