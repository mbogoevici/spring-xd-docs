XD allows you to declaratively specify type conversion within processing streams using _inputType_ and _outputType_ parameters on module definitions. Currently, XD supports the following type conversions commonly used in streams: 

* JSON string <-> [org.springframework.xd.tuple.Tuple] (https://github.com/spring-projects/spring-xd/blob/master/spring-xd-tuple/src/main/java/org/springframework/xd/tuple/Tuple.java) 
* Object <-> JSON String (NOTE: JSON to Object conversion, using Jackson 2, is subject to limitations. XD will attempt the conversion if requested, but YMMV. See the Jackson documentation for more details). 
Object <-> byte[] (Either the raw bytes used for remote transport or converted to bytes using Java serialization (this requires the object to be Serializable).
* JSON string <-> Map
* Object <-> plain text (invokes the object's _toString()_ method)





Registration of custom type converters will likely be supported in a future release. 