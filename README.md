Decription:
==========
 This is just a small project with Continous deployment using a bash script  after the contents are pushed 
 via git to the remote repo. 
 
 The git was pushed via an alias which inturn execute the bashscript update-server.sh in the preceeding directory.
 Alias was set as:
 
 ```
 $ git config alias.finalpush '!git push $1 $2 2>&1| tee ../status.txt && ../update-server.sh'
 ```
 
 Example of running the new alias 
 ```````
$ git finalpush origin master
Everything up-to-date
Nothing to do more
removed ‘/home/ec2-user/domain-test/status.txt’
 ````````
 
 Bash script that triggers the ansible playbook
 ````````
 $ cat ../update-server.sh
 
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
`````````
