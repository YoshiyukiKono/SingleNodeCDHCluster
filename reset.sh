#! /bin/bash

sudo systemctl stop cloudera-scm-agent
sudo systemctl stop cloudera-scm-server

sudo mv /etc/hosts /etc/hosts.org
sudo cp /etc/hosts.template /etc/hosts
sudo sh -c "echo '`hostname -I`  `hostname`' >> /etc/hosts"

sudo mv /etc/cloudera-scm-agent/config.ini /etc/cloudera-scm-agent/config.ini.org
sudo sh -c "sed s/%SERVER_HOST%/`hostname`/ /etc/cloudera-scm-agent/config.ini.template > /etc/cloudera-scm-agent/config.ini"

sudo systemctl start cloudera-scm-agent
sudo systemctl start cloudera-scm-server

sleep 300

curl -X POST -u "admin:admin" http://localhost:7180/api/v11/cm/service/commands/stop

sleep 30

curl -X POST -u "admin:admin" http://localhost:7180/api/v11/cm/service/commands/start

sleep 30

curl -X POST -u "admin:admin" -i -H "content-type:application/json" -d '{"restartOnlyStaleServices": false, "redeployClientConfiguration": true}' http://localhost:7180/api/v11/clusters/OneNodeCluster/commands/restart
