# Changelog

## Version 1.4.1 - 2013-xx-xx

* fix maildir adapter bug where subscribers in the same process where not loaded
* fix redis adapter bug where subscribers where not deleted if the topic was 
  removed.

## Version 1.4.0 - 2012-10-31

* Switch to 'kjess' as the Kestrel client.

## Version 1.3.6 - 2012-09-06

* Pass options to the Adapters (thanks rafer)

## Version 1.3.5 - 2012-09-06

* Rename 'Drainer' to 'BatchConsumer' and add documentation (issue #11, thanks rafer)

## Version 1.3.4 - 2012-08-23

* Add 'Drainer' class (issue #10, thanks rafer)

## Version 1.3.3 - 2012-08-06

* Fix newline bug (issue #9, thanks rafer)

## Version 1.3.2 - 2012-07-17

* Make Queue#consume non-blocking everywhere (issue #7, thanks rafer)

## Version 1.3.1 - 2012-06-21

* Add Consumer#depth
* Check if the data payload is marshalled data and unmarshal it if it is.

## Version 1.2.2 - 2012-05-17

* Use the thrift interface to kestrel instead of the memcache interface

## Version 1.2.0 - 2012-03-17

* Persistent subscriptions for the Redis Adapter (issue #2, thanks aniero)

## Version 1.1.0 - 2012-03-12

* Addition of a Redis Adapter (issue #1, thanks aniero)

## Version 1.0.0 - 2012-03-10

* Initial public release

