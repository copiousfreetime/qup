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

    # Internal: Creates a Publisher for the Topic
    #
    # Returns a new Publisher
    def publisher
      ::Qup::Publisher.new( self )
    end

    # Internal: Create and register a subscriber for the Topic
    #
    # name - the String name of the subscriber
    #
    # Creating a subscriber creates a new Subscriber that will receive a copy of
    # every message that is published to the Topic.
    #
    # Returns a Subscriber
    def subscriber(name)
      subscriber_name = "#{@name}.#{name}"
      @client.sadd @name, subscriber_name
      queue = ::Qup::Adapter::Redis::Queue.new(@uri, subscriber_name, @name)
      ::Qup::Subscriber.new( self, queue )
    end

    # Internal: Return the number of Subscribers to this Topic
    #
    # Returns integer
    def subscriber_count
      subscribers.size
    end

    # Internal: Publish a Message to all the Subscribers
    #
    # message - the Object to send to all subscribers
    #
    # Returns nothing
    def publish( message )
      subscribers.each do |subscriber|
        @client.lpush subscriber, message
      end
    end

    #######
    private
    #######

    # Private: retrieve the current list of subscribers
    #
    # Returns an array of subscriber queue names
    def subscribers
      @client.smembers @name
    end

  end
end
