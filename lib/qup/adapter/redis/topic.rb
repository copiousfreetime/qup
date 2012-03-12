require 'qup/adapter/redis/connection'

class Qup::Adapter::Redis
  #
  # Internal: The Qup implementation for a Redis Topic
  #
  # Based on the API requirements, this is not implemented with Redis pub/sub,
  # rather it guarantees durability of all published messages by using
  # sub-queues internally to deliver messages to subscribers.
  #
  class Topic < Connection
    include Qup::TopicAPI

    # Internal: create a new Topic
    #
    # uri  - the connection uri for the Redis Client
    # name - the String name of the Topic
    #
    # Returns a new Topic.
    def initialize(uri, name)
      super
      @subscribers = Hash.new
    end

    # Internal: Creates a Publisher for the Topic
    #
    # Returns a new Publisher
    def publisher
      ::Qup::Publisher.new( self )
    end

    # Internal: Create a subscriber for the Topic
    #
    # name - the String name of the subscriber
    #
    # Creating a subscriber creates a new Subscriber that will receive a copy of
    # every message that is published to the Topic.
    #
    # Returns a Subscriber
    def subscriber(name)
      ::Qup::Subscriber.new( self, subscriber_queue_for(name) )
    end

    # Internal: Return the number of Subscribers to this Topic
    #
    # Returns integer
    def subscriber_count
      @subscribers.size
    end

    # Internal: Publish a Message to all the Subscribers
    #
    # message - the Object to send to all subscribers
    #
    # Returns nothing
    def publish( message )
      @subscribers.values.each do |subscriber|
        subscriber.produce message
      end
    end

    #######
    private
    #######

    # Private: create and register new sub-Queue for the given subscriber
    #
    # name - the name of the subscriber
    #
    # Returns a Queue
    def subscriber_queue_for(name)
      @subscribers[name] ||=
        ::Qup::Adapter::Redis::Queue.new(@uri, "#{@name}-#{name}")
    end
  end
end
