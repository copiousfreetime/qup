require 'qup/adapter'
require 'kestrel-client'

class Qup::Adapter
  # Internal: The backing adapter for Qup that uses Kestrel as the messaging
  # infrastructure
  class Kestrel < ::Qup::Adapter

    # Register this adapter as :kestrel
    register :kestrel

    # Internal: Create a new Kestrel Adapter
    #
    # uri - the URI instance for this adapter to use
    def initialize( uri, options = {} )
      @uri        = uri
      @addr       = "#{@uri.host}:#{@uri.port}"
      @options    = options
      @closed     = false
    end

    # Internal: Create a new Queue from this Adapter
    #
    # name - the String name of the Queue
    #
    # Returns a Qup::Queue
    def queue( name )
      Qup::Adapter::Kestrel::Queue.new( @addr, name )
    end

    # Internal: Create a new Topic from this Adapter
    #
    # name - the name of this Topic
    #
    # Returns a Qup::Topic
    def topic( name )
      Qup::Adapter::Kestrel::Topic.new( @addr, name )
    end

    # Internal: Close the Kestrel adapter
    #
    # Return nothing
    def close
      @closed = true
    end

    # Internal: Is the Kestrel Adapter closed
    #
    # Returns true or false
    def closed?
      @closed
    end
  end
end
require 'qup/adapter/kestrel/queue'
require 'qup/adapter/kestrel/topic'
