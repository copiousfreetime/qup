queue     = Queue.new( 'foo', :uri => "scheme://user:pass@host:port/" )
producer  = queue.producer
consumer  = queue.consumer

topic      = Topic.new( 'bar', :uri => 'scheme://user:pass@host:port/' )
publisher  = topic.publisher
subscriber = topic.subscriber


###################################################################
session   = Session.new( 'scheme://user:pass@host:port/' )
topic     = session.topic( 'bar' )
queue     = session.queue( 'foo' )


producer  = session.producer_for( Queue.new('foo') )
consumer  = session.consumer_for( Queue.new('foo') )

publisher  = session.publisher_for( Topic.new( 'foo' ) )
subscriber = session.subscriber_for( Topic.new( 'foo' ) )

topic      = session.topic( 't' )
subscriber = Subscriber.new( 'someid' )
topic.add_subscriber( subscriber )
subscriber.subscribe( topic )


