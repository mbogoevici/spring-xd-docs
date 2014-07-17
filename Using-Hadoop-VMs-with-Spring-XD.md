There are several ready-to-use Hadoop virtual machines that you can download from the major vendors:

* [Cloudera](#wiki-cloudera-quickstart-vm)
* [Hortonworks](#wiki-hortonworks-sandbox)
* [Pivotal](#wiki-pivotal-hd-single-node-vm)

They all require a little bit of tweaking to be used from Spring XD running outside of the VM.

## Cloudera QuickStart VM

Download from [Cloudera](http://www.cloudera.com/content/support/en/downloads.html) - for this guide we used version 5.0.0 for VMware.

**Create `/xd` directory:**

Start the VM and open a terminal window. We need to create the `/xd` directory and give us full access rights to it. Enter the following commands:

```
sudo -u hdfs hdfs dfs -mkdir /xd
sudo -u hdfs hdfs dfs -chmod 777 /xd
``` 

We have not been able to modify the VM so that we can access HDFS from the host system. We recommend that you install Spring XD on the VM and test from there.

**Adjust the YARN memory setting:**

The memory setting for YARN isn't enough to run the XD MapReduce jobs. Open the Cloudera Manager and go to the 'yarn' service. Then select "Configuration - View and Edit". Under the "ResourceManager Base Group" category there is a "Resource Management" option. Under there, you should see "Container Memory Maximum" (yarn.scheduler.maximum-allocation-mb). Change that to be 2 GiB. Save the changes and restart 
the 'yarn' service.

**Using with Spring XD**

If you run MapReduce jobs you should also add the YARN application classpath to the hadoop configuration. You can change the `<hadoop:configuration>` entry 
in the Spring configuration file for your job to the following:

```
	<hadoop:configuration>
		fs.default.name=${hd.fs}
		yarn.application.classpath=$HADOOP_CLIENT_CONF_DIR,$HADOOP_CONF_DIR,$HADOOP_COMMON_HOME/*,$HADOOP_COMMON_HOME/lib/*,$HADOOP_HDFS_HOME/*,$HADOOP_HDFS_HOME/lib/*,$HADOOP_YARN_HOME/*,$HADOOP_YARN_HOME/lib/*,$HADOOP_MAPRED_HOME/*,$HADOOP_MAPRED_HOME/lib/*,$MR2_CLASSPATH
	</hadoop:configuration>
``` 

Remember to use the `--hadoopDistro cdh5` when you start Spring XD and the Spring XD Shell.


### Hortonworks Sandbox

Download from [Hortonworks](http://hortonworks.com/products/hortonworks-sandbox/) - for this guide we used Hortonworks Sandbox Version 2.1 for VMware.

Import the VM and start it. The VM will display a banner page showing what IP address it is using. 

**Create `/xd` directory:**

Connect to the VM using ssh, logging in as root (instructions are on the banner page of the Sandbox VM).

We need to create the `/xd` directory and give us full access rights to it. Enter the following commands:

```
sudo -u hdfs hdfs dfs -mkdir /xd
sudo -u hdfs hdfs dfs -chmod 777 /xd
``` 

**Add /etc/hosts sandbox entry on your local system:**

Add the IP address from the Sandbox VM banner to /etc/hosts
`172.16.87.154   sandbox sandbox.hortonworks.com`

**Using with Spring XD**

You can now target `hdfs://sandbox:8020` in the XD shell and in _/config/servers.yml_

If you run MapReduce jobs you should also add the YARN application classpath to the hadoop configuration. You also need to add the address for the resource manager. You can change the `<hadoop:configuration>` entry in the Spring configuration file for your job to the following:

```
    <hadoop:configuration>
        fs.default.name=hdfs://sandbox:8020
        yarn.resourcemanager.address=sandbox:8050
        yarn.application.classpath=/etc/hadoop/conf,/usr/lib/hadoop/*,/usr/lib/hadoop/lib/*,/usr/lib/hadoop-hdfs/*,/usr/lib/hadoop-hdfs/lib/*,/usr/lib/hadoop-yarn/*,/usr/lib/hadoop-yarn/lib/*,/usr/lib/hadoop-mapreduce/*,/usr/lib/hadoop-mapreduce/lib/*
    </hadoop:configuration>
``` 

Remember to use the `--hadoopDistro hdp21` when you start Spring XD and the Spring XD Shell.


### Pivotal HD Single Node VM

Download from [Pivotal](https://network.gopivotal.com/products/pivotal-hd) - for this guide we used "Pivotal HD 2.0 Single Node VM".

Start the VM and open a terminal window (Applications -> System Tools -> Terminal). 

**Modify the /etc/hosts entry:**

First find out the IP address for the eth1 network connection

```
$ ifconfig
eth1      Link encap:Ethernet  HWaddr 00:0C:29:B6:20:72  
          inet addr:192.168.177.147  Bcast:192.168.177.255  Mask:255.255.255.0
          ...
```

Now edit /etc/hosts and modify the pivhdsne entry so the file looks like below using the IP address from above

```
$ sudo vi /etc/hosts
------------------
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.177.147   pivhdsne pivhdsne.localdomain
```

**Start Pivotal HD:**

Double click the `start_all.sh` icon on the desktop. Pick the "Run in Terminal" option so you can see the startup progress.

**Create `/xd` directory:**

We need to create the `/xd` directory and give us full access rights to it. In the terminal window enter the following commands:

```
sudo -u hdfs hdfs dfs -mkdir /xd
sudo -u hdfs hdfs dfs -chmod 777 /xd
``` 

**Add /etc/hosts pivhdsne entry on your local system:**

Add the IP address from above to /etc/hosts
`192.168.177.147   pivhdsne pivhdsne.localdomain`

**Using with Spring XD**

You can now target `hdfs://pivhdsne:8020` in the XD shell and in _/config/servers.yml_

If you run MapReduce jobs you should also add the YARN application classpath to the hadoop configuration. You also need to add the address for the resource manager
and for the job history server. You can change the `<hadoop:configuration>` entry in the Spring configuration file for your job to the following:

```
    <hadoop:configuration>
        fs.default.name=hdfs://pivhdsne:8020
        yarn.resourcemanager.address=pivhdsne:8032
        mapreduce.jobhistory.address=pivhdsne:10020
        yarn.application.classpath=$HADOOP_CONF_DIR,$HADOOP_COMMON_HOME/*,$HADOOP_COMMON_HOME/lib/*,$HADOOP_HDFS_HOME/*,$HADOOP_HDFS_HOME/lib/*,$HADOOP_MAPRED_HOME/*,$HADOOP_MAPRED_HOME/lib/*,$HADOOP_YARN_HOME/*,$HADOOP_YARN_HOME/lib/*,$USS_CONF/,$USS_HOME/*
    </hadoop:configuration>
``` 

Remember to use the `--hadoopDistro phd20` when you start Spring XD and the Spring XD Shell.
