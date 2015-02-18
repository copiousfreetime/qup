require 'qup/adapter/redis/connection'

class Qup::Adapter::Redis
  #
  # Internal: The Qup implementation for a Redis Queue
  #
  class Queue < Connection
    include Qup::QueueAPI

    # Internal: create a new Queue
    #
    # client     - the Redis client
    # name       - the String name of the Queue
    # topic_name - (optional) the String name of a parent topic
    #
    # Returns a new Queue.
    def initialize( client, name, topic_name = nil )
      super( client, name )
      @topic_name = topic_name
      @open_messages = {}
    end

    # Internal: Destroy the queue
    #
    # Removes the list from redis.
    #
    # Returns nothing.
    def destroy
      @client.del name
      @client.srem @topic_name, name if @topic_name
    end

    # Internal: Empty the queue
    #
    # In redis, this is accomplished by merely deleting the list. If anything
    # new is added to it, the key is re-created on the server
    #
    # Returns nothing
    alias :flush :destroy

    # Internal: return the number of Messages on the Queue
    #
    # Returns an integer of the Queue depth
    def depth
      @client.llen name
    end

    # Internal: Acknowledge that message is completed and remove it from the
    # Queue.
    #
    # In redis, this doesn't do anything at all. The tracking is only performed
    # to meet the API requirements.
    #
    # Returns nothing.
    def acknowledge( message )
      open_msg = @open_messages.delete( message.key )
      raise Qup::Error, "Message #{message.key} is not currently being consumed" unless open_msg
    end

    # Internal: Put an item onto the Queue
    #
    # message - the data to put onto the queue.
    #
    # The 'message' that is passed in is wrapped in a Qup::Message before being
    # stored.
    #
    # Returns the Message that was put onto the Queue
    def produce( message )
      @client.lpush name, message
      return ::Qup::Message.new( message.object_id, message )
    end

    # Internal: Retrieve a Message from the Queue
    #
    # Yields a Message
    #
    # Returns a Message
    def consume(&block)
      data = @client.rpop( name )
      return if data.nil?
      message = ::Qup::Message.new( data.object_id, data )
      @open_messages[message.key] = message
      if block_given? then
        yield_message( message, &block )
      else
        return message
      end
    end

    #######
    private
    #######

    def yield_message( message, &block )
      yield message
    ensure
      acknowledge( message )
    end

  end
end
