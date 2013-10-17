XD allows you to declaratively specify type conversion within processing streams using _inputType_ and _outputType_ parameters on module definitions. Currently, XD supports the following type conversions commonly used in streams: 

* __JSON <-> [org.springframework.xd.tuple.Tuple](https://github.com/spring-projects/spring-xd/blob/master/spring-xd-tuple/src/main/java/org/springframework/xd/tuple/Tuple.java)__
* __Object -> JSON String__ (JSON to Object is supported. NOTE: It is not possible to convert a JSON string to an arbitrary object without knowing the target class) 
* __Object <-> byte\[]__ (Either the raw bytes used for remote transport or converted to bytes using Java serialization -- this requires the object to be Serializable)
* __JSON  <-> Map__
* __Object <-> plain text__ (invokes the object's _toString()_ method)

Where _JSON_ represents JSON content in the form of a String. Registration of custom type converters will likely be supported in a future release.

## MIME media types
_inputType_ and _outputType_ values are parsed as media types, e.g., _application/json_ or _text/plain;charset=UTF-8_. Media types are especially useful for indicating how to interpret String or byte[] content. XD also uses standard media type format to represent Java types, using the general type _application/x-java-object_ with a _type_ parameter. For example, _application/x-java-object;type=java.util.Map_ or _application/x-java-object;type=com.bar.Foo_ . For convenience, you can specify the class name by itself and XD will map it to the corresponding media type. In addition, XD provides a namespace for internal types, notably, _application/x-xd-tuple_ to specify a Tuple. 

## Stream Definition examples

           twittersearch --outputType=application/json |  file

The _twittersearch_ module produces [Tweet](https://github.com/spring-projects/spring-social-twitter/blob/master/spring-social-twitter/src/main/java/org/springframework/social/twitter/api/Tweet.java) objects. Producing a domain object is useful in many cases, however writing a Tweet directly to a file would produce something like:

org.springframework.social.twitter.api.Tweet@6e878e7c

Arguably, this output is not as useful as the JSON representation. Setting the outputType to application/json causes XD to convert the default type to a JSON string before piping it to the next module. This is almost equivalent to:

           twittersearch | file --inputType=application/json

There are some technical differences: In the first case, the transformation is done before the object is marshalled (serialized) for remote transport. In the second case, the transformation follows unmarshalling. Perhaps a more significant difference is that a tap created on the file sink would consume JSON in the first case, and Tweets in the second. 


           twittersearch --outputType=application/json |  transform --inputType=application/x-xd-tuple ...

The above example illustrates a combination of outputType and inputType conversion. the Tweet is converted to a JSON string which is then converted to a Tuple. XD does not know how to convert an arbitrary type to a Tuple, but it can write an object to JSON and read JSON into a Tuple, so we have effectively performed an Object to Tuple conversion.  In many cases, combining conversion this way is not necessary, and care must be taken since XD does not validate that such combinations are possible.

The following serializes a java.io.Serializable object to a file.  Presumably the _foo_ module outputs a Serializable type. If not, this will result in an exception. If remote transport is configured, the output of _foo_ will be marshalled using XD's internal serialization mechanism. The object will be reconstituted in the _file_ module's local JVM and then converted to a byte array using Java serialization.

         foo  | --inputType=application/x-java-serialized-object file



## Media types and Java types

Internally, XD implements type conversion using Spring Integration's [datatype channels](http://docs.spring.io/spring-integration/docs/latest-ga/reference/htmlsingle/#channel-configuration). The data type channel converts payloads to the configured datatype using Spring's [conversion service](http://docs.spring.io/spring/docs/current/spring-framework-reference/htmlsingle/#core-convert). When XD processes a module with a declared type conversion, it modifies the module's input and/or output channel definition to set the required Java type and register Converters targeting the corresponding Java type to the channels conversion service. This requires that the Java type be determined from the specified media type, as shown below.

| Media Type       | Java Type     | Comments                       |
| ---------------- | ------------- | ------------------------------ |
| application/json | String        ||
| text/plain       | String        |may include a charset parameter|
|application/x-java-serialized-object| byte[] | uses Java serialization|
|application/x-java-object;type=<fullyQualifiedClassName>| the specified class||
|application/x-xd-tuple|org.springframework.xd.tuple.DefaultTuple||
|other|not supported|Will throw a ModuleConfigurationException when the module is deployed|

## Caveats
Note that that inputType and outputType parameters only apply to payloads that require type conversion. For example, if a module produces an XML string and outputType=application/json, the payload will not be converted from XML to JSON. This is because the payload at the module's output channel is already a String so no conversion will be applied at runtime.

