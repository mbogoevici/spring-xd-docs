The Spring XD team is pleased to announce that Spring XD 1.0 Milestone 6 is now available for download.

This is our biggest release ever!  The team has been hard at work and this release contains a weath of new features

* [Distributed and Fault Tolerant Runtime](https://github.com/spring-projects/spring-xd/wiki/XD-Distributed-Runtime) - Leader election among multiple xd-admin severs and automatic redeployment of modules to other xd-containers in the case of failure.  Zookeeper is introduced to manage the cluster and its deployment state.
*  [Deployment Manifest] - When deploying a stream you can provide a deployment manifest that describes how to transform the logical stream definition (e.g.  http | hdfs) to a physical deployment on the cluster.  You can specify the number of instances of each module to deploy and also a criteria expression that selects the target container to run the module.  This will be an area of active development for the next release with support for data partitioning.
* [Run XD on YARN](https://github.com/spring-projects/spring-xd/wiki/Running-on-YARN) - Run admin and container nodes on a HADOOP YARN cluster rather than on VMs or physical servers that you need to manage.  There are simple configuration and shell scripts that make this process very easy.
* [Real-Time Evaluation of Machine Learning Scoring Algorithms](https://github.com/spring-projects/spring-xd/wiki/Analytics) - Integration with the [JPMML-Evaluator](https://github.com/jpmml/jpmml-evaluator) library that provides support for a wide range of [model types](https://github.com/jpmml/jpmml-evaluator#features) and is interoperable with models exported from popular data analysis package such as [R](http://www.r-project.org/).  Integration with other libraries is supported by providing an implementation of XD's Analytic and MappedAnalytic abstractions.
* [Updated UI](https://github.com/spring-projects/spring-xd/wiki/AdminUI) - A redesign and rewrite of the UI that has a modern look and feel.  
* [High performance tcp source] - Based on the Reactor project - the [Reactor TCP source](https://github.com/spring-projects/spring-xd/wiki/Sources#reactor-tcp) on commodity hardware can consume up to ~1 Million msgs/second.
* [FTP to HDFS job](https://github.com/spring-projects/spring-xd/wiki/Batch-Jobs#ftp-to-hdfs-export-ftphdfs) - Out of the box support for jobs to transfer files from FTP to HDFS.


TODO 

* update list of out of the box jobs in wiki doesn't have ftp->hdfs
     

