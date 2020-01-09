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
* Where /home/ec2-user/domain-test was my working directory

NOTE: ansible.pem key is for the ansible to access SSH and github.key is required for cloning the remote private repository

```
$ cat password.yml 
---
- dockpass: your pass  
- repo: your remote git
- localworkdir: /home/ec2-user/domain-test/   # in my case
- dckerusr:  your docker user
```

WORKING:
=========

The changes are made to the contents folder. Once a change is done and pushed to the remote repo using then new alias, the bash script will be trigerred which inturn checks if the prevous output was just an "up-to-date". If not the case, it will inturn trigger the ansible-playbook. The playbook will create a docker image and push to its repo with tag as that of the tag used in the git commit. Also tags the last built to the latest version of the new docker image . The playbook then waits for the docker hub to update the new changes and then runs the new docker container from the new latest image.
