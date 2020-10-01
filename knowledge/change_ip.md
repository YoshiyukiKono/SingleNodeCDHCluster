https://www.quora.com/How-do-I-change-the-IP-of-existing-cloudera-manager-without-disturbing-the-rest-of-nodes

```
Follow these steps:

Shutdown all services
On all nodes, “service cloudera-scm-agent stop”
On the CM server, “service cloudera-scm-server stop”.
Edit the config.ini to point to the new scm server
ip sudo nano /etc/cloudera-scm-agent/config.ini 
Change Host IP sudo nano /etc/hosts 
Restart the service on all node service cloudera-scm-agent restart 
Restart the service on master node service cloudera-scm-server restart
```

```
$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.0.0.78  ip-10-0-0-78.us-east-2.compute.internal
10.0.0.78  ip-10-0-0-78.us-east-2.compute.internal
10.0.0.78  ip-10-0-0-78.us-east-2.compute.internal
[centos@ip-10-0-0-186 ~]$ ls -l /etc/hosts
```


```
sudo mv /etc/hosts /etc/hosts.org
sudo cp /etc/hosts.template /etc/hosts
sudo sh -c "echo '10.0.0.186  ip-10-0-0-186.us-east-2.compute.internal' >> /etc/hosts"
sudo sh -c "echo '`hostname -I`  `hostname`' >> /etc/hosts"
```

```
sudo mv /etc/cloudera-scm-agent/config.ini /etc/cloudera-scm-agent/config.ini.org
sudo sh -c "sed s/%SERVER_HOST%/`hostname`/ /etc/cloudera-scm-agent/config.ini.template > /etc/cloudera-scm-agent/config.ini"
```

```
$ sudo systemctl start cloudera-scm-agent
$ sudo systemctl start cloudera-scm-server
```

## Restart CM Service

https://stackoverflow.com/questions/34648532/what-is-rest-api-to-start-cloudera-management-service

https://cloudera.github.io/cm_api/apidocs/v11/path__cm_service_commands_start.html

```
$ curl -X POST -u "admin:admin" http://localhost:7180/api/v11/cm/service/commands/stop
{
  "id" : 316,
  "name" : "Stop",
  "startTime" : "2020-10-01T01:30:05.227Z",
  "active" : true,
  "serviceRef" : {
    "serviceName" : "mgmt"
  }
}
$ curl -X POST -u "admin:admin" http://localhost:7180/api/v11/cm/sevice/commands/start
{
  "id" : 321,
  "name" : "Start",
  "startTime" : "2020-10-01T01:30:28.005Z",
  "active" : true,
  "serviceRef" : {
    "serviceName" : "mgmt"
  }
}
```

```
$ curl -X POST -u "admin:admin" http://localhost:7180/api/v11/clusters/OneNodeCluster/commands/start
{
  "id" : 338,
  "name" : "Start",
  "startTime" : "2020-10-01T01:37:29.345Z",
  "active" : true,
  "clusterRef" : {
    "clusterName" : "OneNodeCluster"
  }
}
```
https://cloudera.github.io/cm_api/apidocs/v11/ns0_apiRestartClusterArgs.html

```
$ curl -X POST -u "admin:admin" -i -H "content-type:application/json" -d '{"restartOnlyStaleServices": false, "redepoyClientConfiguration": true}' http://localhost:7180/api/v11/clusters/OneNodeCluster/commands/restart
HTTP/1.1 200 OK
Date: Thu, 01 Oct 2020 01:48:25 GMT
Set-Cookie: CLOUDERA_MANAGER_SESSIONID=node05bfgnzttca43emotzabzwuci33.node0;Path=/;HttpOnly
Expires: Thu, 01 Jan 1970 00:00:00 GMT
Content-Type: application/json;charset=utf-8
X-XSS-Protection: 1; mode=block
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Transfer-Encoding: chunked

{
  "id" : 356,
  "name" : "Restart",
  "startTime" : "2020-10-01T01:48:25.347Z",
  "active" : true,
  "clusterRef" : {
    "clusterName" : "OneNodeCluster"
  }
}
```

https://cloudera.github.io/cm_api/docs/quick-start/


