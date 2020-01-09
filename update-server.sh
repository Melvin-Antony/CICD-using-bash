#!/bin/bash
statusfile="/home/ec2-user/domain-test/status.txt"
if [ ! -f  ${statusfile} ] ; then
	echo "Exiting as status.txt not found" 
	exit 2
fi

if [ $(wc -l ${statusfile}| awk '{print $1}') -gt 1 ];
then

cd /home/ec2-user/domain-test
ansible-playbook -i hosts deploy.yml

else
	echo "Nothing to do more"
fi

rm -fv ${statusfile}
