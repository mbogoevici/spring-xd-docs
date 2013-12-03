**NOTE:  This was taken from a prototype of the XD analytics package.**

## Redis based Aggregate Field Value Counters

Here is a summary of counter types and their behavior based on when messages are process by a sink associated with each counter type.
* Aggregate counters accumulate historical and total counts of fields in a message.
* Field Value Counters accumulate total counts based on the field/value pairs present in messages, 
* Aggregate Field Value counters accumulate historical and total counts based on the field/value pairs in messages.

There is a new sink type, 'aggregatefieldvaluecounter' that works as follows.  Given the stream definition

     http --port=8001 --uripath=${kodiak.stream.name} | aggregatefieldvaluecounter --keyname=${kodiak.stream.name} --fields=foo,bar 

and posting data to the 'test' stream.

     curl -X POST -H "Content-Type: text/json" -d "{\"foo\":\"a\"}" http://localhost:8001/test
     
     curl -X POST -H "Content-Type: text/json" -d "{\"foo\":\"a\"}" http://localhost:8001/test
     
     curl -X POST -H "Content-Type: text/json" -d "{\"foo\":\"b\",\"bar\":\"x\"}" http://localhost:8001/test

Then in redis will be the following key structure (re-ordered for better readability) 

     "counters:aggfield:test:bar:field:x:total"
     "counters:aggfield:test:bar:field:x:years"
     "counters:aggfield:test:bar:field:x:2013"
     "counters:aggfield:test:bar:field:x:201303"
     "counters:aggfield:test:bar:field:x:20130304"
     "counters:aggfield:test:bar:field:x:2013030416"

     "counters:aggfield:test:foo:field:a:total"
     "counters:aggfield:test:foo:field:a:years"
     "counters:aggfield:test:foo:field:a:2013"
     "counters:aggfield:test:foo:field:a:201303"
     "counters:aggfield:test:foo:field:a:20130304"
     "counters:aggfield:test:foo:field:a:2013030416"

     "counters:aggfield:test:foo:field:b:total"
     "counters:aggfield:test:foo:field:b:years"
     "counters:aggfield:test:foo:field:b:2013"
     "counters:aggfield:test:foo:field:b:201303"
     "counters:aggfield:test:foo:field:b:20130304
     "counters:aggfield:test:foo:field:b:2013030416"

The list of all the fields in the 'test' stream are in the key

     "counters:aggfield:test:fields"

The list of all the field values in for each field in the stream are in the keys

     "counters:aggfield:test:bar:fields"
     "counters:aggfield:test:foo:fields"

The data inside a few keys are

     redis 127.0.0.1:6379> smembers counters:aggfield:test:fields
     1) "foo"
     2) "bar"

     redis 127.0.0.1:6379> smembers counters:aggfield:test:foo:fields
     1) "a"
     2) "b"

     redis 127.0.0.1:6379> smembers counters:aggfield:test:bar:fields
     1) "x"

     redis 127.0.0.1:6379> hgetall counters:aggfield:test:foo:field:b:20130304
     1) "17"
     2) "1"
     redis 127.0.0.1:6379> hgetall counters:aggfield:test:foo:field:a:20130304   
     1) "17"
     2) "2"
     redis 127.0.0.1:6379> hgetall counters:aggfield:test:bar:field:x:20130304
     1) "17"  
     2) "1"

## Example Request Response

To access the data over http, the following endpoints are available

     http://localhost:8080/stream-server/streams/afv/counts/{streamName}/fields
     http://localhost:8080/stream-server/streams/afv/counts/{streamName}/{fieldName}/fields
     http://localhost:8080/stream-server/streams/afv/counts/{streamName}/{fieldName}/{fieldValue}

The naming is a bit odd, sorry for that - it matches well with the key names in redis ATM.  Note that 'afv' stands for 'aggregate field value'

To get the list of fields for which we will store the aggregate counts of field/value pairs for a stream
```
http://localhost:8080/stream-server/streams/afv/counts/test/fields
["bar","foo"]
```

To get the list of fields for a specific field name, 
```
http://localhost:8080/stream-server/streams/afv/counts/test/bar/fields
["x"]

http://localhost:8080/stream-server/streams/afv/counts/test/foo/fields
["b","a"]
```

To get the aggregate counter for the field-value pairs
```
http://localhost:8080/stream-server/streams/afv/counts/test/foo/a

{
  "id": "aggfield:test:foo:field:a",
  "totalCount": 2,
  "yearlyCounts": {
    "2013": 2
  },
  "monthlyCountsForYear": {
    "3": 2
  },
  "dayCountsForMonth": {
    "4": 2
  },
  "hourCountsForDay": {
    "19": 2
  },
  "minCountsForHour": {
    "30": 2
  }
}

http://localhost:8080/stream-server/streams/afv/counts/test/foo/b
{
  "id": "aggfield:test:foo:field:b",
  "totalCount": 1,
  "yearlyCounts": {
    "2013": 1
  },
  "monthlyCountsForYear": {
    "3": 1
  },
  "dayCountsForMonth": {
    "4": 1
  },
  "hourCountsForDay": {
    "19": 1
  },
  "minCountsForHour": {
    "30": 1
  }
}
```
Note that this sample data is very minimal - you should expect a map of values under each key.  Here is some data taken at a later time after some more 'a' values were published

```
http://localhost:8080/stream-server/streams/afv/counts/test/foo/a


{
  "id": "aggfield:test:foo:field:a",
  "totalCount": 8,
  "yearlyCounts": {
    "2013": 8
  },
  "monthlyCountsForYear": {
    "3": 8
  },
  "dayCountsForMonth": {
    "4": 8
  },
  "hourCountsForDay": {
    "19": 2,
    "20": 6
  },
  "minCountsForHour": {
    "2": 2,
    "4": 4
  }
}

