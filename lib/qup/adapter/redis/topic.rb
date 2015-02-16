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
      queue = ::Qup::Adapter::Redis::Queue.new(@client, subscriber_name, @name)
      ::Qup::Subscriber.new( self, queue )
    end

    # Internal: Destroy the topic and all of its subscribers
    #
    # Returns nothing
    def destroy
      subscribers.each do |name, subscriber|
        subscriber.destroy
      end
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
      subscribers.each do |name, subscriber|
        subscriber.produce( message )
      end
    end

    #######
    private
    #######

    # Private: retrieve the current list of subscriber names
    #
    # Returns an array of subscriber queue names
    def subscriber_names
      @client.smembers @name
    end

    # Private: return the current list of subscribers
    #
    # Return a Hash of subscriber names and queues
    def subscribers
      subs = {}
      subscriber_names.each do |sname|
        subs[sname] = ::Qup::Adapter::Redis::Queue.new(@client, sname, @name)
      end
      return subs
    end
  end
end
