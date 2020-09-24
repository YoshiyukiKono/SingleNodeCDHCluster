# Single Node CDH Cluster 

This script automatically sets up a CDH cluster on the public cloud (AWS) on a single VM with the following services:

- Kafka
- HBase
- Kudu
- Impala
- Hue
- Hive
- Spark
- Oozie
- HDFS
- YARN
- ZooKeeper

## Instructions

Below are instructions for creating the cluster.

### Provisioning Cluster without CDSW
- Create a Centos 7 VM with at least 8 vCPUs/ 32 GB RAM. Choose the plain vanilla Centos image, not a cloudera-centos image.
  - e.g., CentOS Linux 7 x86_64 HVM EBS ENA ('Ohio' Region AMI ID: "ami-01e36b7901e884a10")
- OS disk size: at least 50 GB.

### Configuration and installation
- add 2 inbound rules to the Security Group:
  - to allow your IP only, for all ports.
  - to allow the VM's own IP, i.e., your Security Group, for all ports.
  
### Procedure
- ssh into VM
- run the subsequent processes as root account
```
$ sudo su -
```
- install git command
```
# yum install -y git
```
- clone this project and change directory to the root of this project
```
# git clone <Repository URL>
# cd <Repository Name>
```

The script `setup.sh` takes 1 arguments:
- the template file.

Example: create cluster using base_template.json
```
$ ./setup.sh base_template.json
```

Wait until the script finishes, check for any error.

You can check if Cloudera Manager Server is running as follows.
```
# systemctl status cloudera-scm-server
● cloudera-scm-server.service - Cloudera CM Server Service
   Loaded: loaded (/usr/lib/systemd/system/cloudera-scm-server.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2020-09-24 01:22:10 UTC; 26min ago
```
## Use

Once the script returns, you can open Cloudera Manager at [http://\<public-IP\>:7180](http://<public-IP>:7180)


## Troubleshooting and known issues

### Kudu
**Clock Offset**: the NTPD service which is required by Kudu and the Host is not installed. For the moment, just put
`--use-hybrid-clock=false`  in Kudu's Configuration property `Kudu Service Advanced Configuration Snippet (Safety Valve) for gflagfile` and suppressed all other warnings.


