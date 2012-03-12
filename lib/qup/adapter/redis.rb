require 'qup/adapter'
require 'redis'

class Qup::Adapter
  # Internal: The backing adapter for Qup that uses Redis as the messaging
  # infrastructure
  class Redis < ::Qup::Adapter

    # Register this adapter as :redis
    register :redis

    # Internal: Create a new Redis Adapter
    #
    # uri - the URI instance for this adapter to use
    def initialize( uri, options = {} )
      @uri        = uri
      @options    = options
      @closed     = false
    end

    # Internal: Create a new Queue from this Adapter
    #
    # name - the String name of the Queue
    #
    # Returns a Qup::Queue
    def queue( name )
      Qup::Adapter::Redis::Queue.new( @uri, name )
    end

    # Internal: Create a new Topic from this Adapter
    #
    # name - the name of this Topic
    #
    # Returns a Qup::Topic
    def topic( name )
      Qup::Adapter::Redis::Topic.new( @uri, name )
    end

    # Internal: Close the Redis adapter
    #
    # Return nothing
    def close
      @closed = true
    end

    # Internal: Is the Redis Adapter closed
    #
    # Returns true or false
    def closed?
      @closed
    end
  end
end
require 'qup/adapter/redis/queue'
require 'qup/adapter/redis/topic'
