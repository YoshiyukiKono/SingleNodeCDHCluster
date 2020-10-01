#! /bin/bash

sudo mv /etc/hosts /etc/hosts.org
sudo cp /etc/hosts.template /etc/hosts
sudo sh -c "echo '`hostname -I`  `hostname`' >> /etc/hosts"

sudo mv /etc/cloudera-scm-agent/config.ini /etc/cloudera-scm-agent/config.ini.org
sudo sh -c "sed s/%SERVER_HOST%/`hostname`/ /etc/cloudera-scm-agent/config.ini.template > /etc/cloudera-scm-agent/config.ini"

sudo systemctl start cloudera-scm-agent
sudo systemctl start cloudera-scm-server

curl -X POST -u "admin:admin" -i -H "content-type:application/json" -d '{"restartOnlyStaleServices": false, "redepoyClientConfiguration": true}' http://localhost:7180/api/v11/clusters/OneNodeCluster/commands/restart
