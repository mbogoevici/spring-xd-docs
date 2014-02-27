There are several ready-to-use Hadoop virtual machines that you can download from the major vendors. They all require a little bit of tweaking to be used from Spring XD running outside of the VM.

## Cloudera QuickStart VM

Download from [Cloudera](http://www.cloudera.com/content/support/en/downloads.html) - for this guide we used version 4.4.0 for VMware.

**Create `/xd` directory:**

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

Click "Save Changes", no need to restart the service since we will reboot the system soon any way.

**Change VMs hostname:**

Back to the terminal window, run these commands

`$ sudo hostname cdh4`

```
$ sudo vi /etc/sysconfig/network
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
$ sudo vi /etc/hosts
------------------
127.0.0.1   localhost.localdomain   localhost
172.16.87.153   cdh4
```

**Restart VM**

**Add /etc/hosts cdh4 entry on your local system:**

Add the IP address from above to /etc/hosts
`172.16.87.153   cdh4`

You can now target `hdfs://cdh4:8020` in the XD shell and in _/config/hadoop.properties_

Remember to use the `--hadoopDistro cdh4` when you start Spring XD and the Spring XD Shell.



### Hortonworks Sandbox

TBD


### Pivotal HD Single Node VM

Download from [Pivotal](http://gopivotal.com/big-data/pivotal-hd) - for this guide we used version PIVHDSNE110_VMWARE_VM which is based on Pivotal HD 1.1.

Start the VM and open a terminal window (Applications -> System Tools -> Terminal). 

**Modify the /etc/hosts entry:**

First find out the IP address for the eth1 network connection

```
$ ifconfig
eth1      Link encap:Ethernet  HWaddr 00:0C:29:B6:20:72  
          inet addr:192.168.0.106  Bcast:192.168.0.255  Mask:255.255.255.0
          ...
```

Now edit /etc/hosts and modify the pivhdsne entry so the file looks like below using the IP address from above

```
$ sudo vi /etc/hosts
------------------
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.0.106   pivhdsne pivhdsne.localdomain
```

**Start Pivotal HD:**

Double click the `start_all.sh` icon on the desktop. Pick the "Run in Terminal" option so you can see the startup progress.

**Create `/xd` directory:**

We need to create the `/xd` directory and give us full access rights to it. In the terminal window enter the following commands:

```
sudo -u hdfs hdfs dfs -mkdir /xd
sudo -u hdfs hdfs dfs -chmod 777 /xd
``` 

**Add /etc/hosts cdh4 entry on your local system:**

Add the IP address from above to /etc/hosts
`192.168.0.106   pivhdsne pivhdsne.localdomain`

You can now target `hdfs://pivhdsne:8020` in the XD shell and in _/config/hadoop.properties_

Remember to use the `--hadoopDistro phd1` when you start Spring XD and the Spring XD Shell.


