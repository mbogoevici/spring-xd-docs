The demo currently requires a Redis instance on localhost. Install [Redis](http://redis.io/) if you have not already, and then start the server:

````
redis-server
````

The gradle build script within the root directory of the spring-xd repository contains a 'launch' task. That task is actually correlated with the 'spring-xd-dirt' subproject, but can be executed from the root directory:

````
./gradlew launch
````

That will start an instance of the StreamServer, which is a very basic REST API (to be replaced/expanded) that enables submitting _streams_. In the simplest form a stream consists of two _modules_: a _source_ and a _sink_. When the StreamServer starts, it also starts a single instance of a module _Container_. The Container is simply a Spring application that listens to a Redis queue for requests to start modules. The Container delegates to a ModuleRegistry to lookup the actual module definitions. Currently a File-based implementation of that registry is used and the module definitions - themselves Spring application configuration files - are stored within the 'modules' directory within the spring-xd repository. The modules are organized by type within sub-directories (e.g. the 'source' directory contains modules whose type is source and can be the initial module listed for a stream).

If you look within the modules/source and modules/sink directories you will see what modules are currently available. A stream can be POSTed to the StreamServer via the url localhost:8080/streams/{streamName} as follows:

````
curl -X POST -d "source | sink" http://localhost:8080/streams/example
````

If a module configuration file contains property placeholders (e.g. value="${paramName}"), those values can be provided in the stream definition as --paramName=paramValue, e.g.

````
curl -X POST -d "twittersearch --query=spring | hdfs --directory=/tweets/" http://localhost:8080/streams/springtweets
````

A _tap_ acts like a source in that it occurs as the first module within a stream and can pipe its output to a sink (and/or one or more processors added to a chain before the ultimate sink), but for a tap the messages are actually those being produced by some other source. The basic idea is to add a "tee" stream so that realtime analytics may be performed at the same time as data is being ingested via its primary stream. Typically a counter or gauge would follow the pipe after a tap. Here's an example:

````
curl -X POST -d "tap @ springtweets | counter --name=tweetcount" http://localhost:8080/streams/tweettap
````
