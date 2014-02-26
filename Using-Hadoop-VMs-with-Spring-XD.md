There are several ready-to-use Hadoop virtual machines that you can download from the major vendors.

## Cloudera QuickStart VM

Download from [Cloudera](http://www.cloudera.com/content/support/en/downloads.html) - for this guid we used version 4.4.0 for VMware.

Start the VM and open a terminal window. We need to create the `/xd` directory and give us full access rights to it. Enter the following commands:

```
sudo -u hdfs hdfs dfs -mkdir /xd
sudo -u hdfs hdfs dfs -chmod 777 /xd
``` 

We also need to change the hostname settings so we can access HDFS from outside the VM.

**In Cloudera Manager change to use hostname:**

Service-Wide -> Ports and Addresses -> Use DataNode Hostname [✓]

**Change VMs hostname:**

`sudo hostname cdh4`

`sudo vi /etc/sysconfig/network`
```
NETWORKING=yes
HOSTNAME=cdh4
```

**Add /etc/hosts entry:**

First find out the IP address for the eth1 network connection

```
$ ifconfig
eth1      Link encap:Ethernet  HWaddr 00:0C:29:9D:18:32  
          inet addr:172.16.87.153  Bcast:172.16.87.255  Mask:255.255.255.0
          ...
```

Now edit /etc/hosts and add an entry for cdh4 using IP address from above

`sudo vi /etc/hosts`
```
127.0.0.1   localhost.localdomain   localhost
172.16.87.153   cdh4
```

**Restart VM**


### Hortonworks Sandbox

### Pivotal HD Single Node VM