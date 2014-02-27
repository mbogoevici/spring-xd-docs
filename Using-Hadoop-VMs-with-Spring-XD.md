There are several ready-to-use Hadoop virtual machines that you can download from the major vendors. They all require a little bit of tweaking to be used from Spring XD running outside of the VM.

## Cloudera QuickStart VM

Download from [Cloudera](http://www.cloudera.com/content/support/en/downloads.html) - for this guide we used version 4.4.0 for VMware.

Start the VM and open a terminal window. We need to create the `/xd` directory and give us full access rights to it. Enter the following commands:

```
sudo -u hdfs hdfs dfs -mkdir /xd
sudo -u hdfs hdfs dfs -chmod 777 /xd
``` 

We also need to change the hostname settings so we can access HDFS from outside the VM.

**In Cloudera Manager change to use hostname:**

Start the Firefox browser. The home page should have a link to start "Cloudera Manager". Start "Cloudera Manager" and log in. Click on the "hdfs1" service. Now, click on "Configuration" -> "View and Edit".

You should now have the configuration screen open. Under Category / Default in left hand navigation tree navigate to and modify:

    Service-Wide -> Ports and Addresses -> Use DataNode Hostname [✓]

**Change VMs hostname:**

Back to the command line, run these commands

`sudo hostname cdh4`

```
sudo vi /etc/sysconfig/network
------------------------------
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

```
sudo vi /etc/hosts
------------------
127.0.0.1   localhost.localdomain   localhost
172.16.87.153   cdh4
```

**Restart VM**

**Add /etc/hosts cdh4 entry on your local system:**

Add the IP address from above to /etc/hosts
`172.16.87.153   cdh4`

You can now target `hdfs://cdh4:8020` in the XD shell and in _/config/hadoop.properties_


### Hortonworks Sandbox

TBD


### Pivotal HD Single Node VM

TBD
