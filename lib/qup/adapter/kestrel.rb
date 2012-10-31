require 'qup/adapter'
require 'kjess'

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
      @host       = @uri.host
      @port       = @uri.port.to_i
      @client_options = options.merge( :host => @host, :port => @port )
      @client     = KJess::Client.new( @client_options )
      @client.ping
      @closed     = false
    end

    # Internal: Create a new Queue from this Adapter
    #
    # name - the String name of the Queue
    #
    # Returns a Qup::Queue
    def queue( name )
      Qup::Adapter::Kestrel::Queue.new( @client, name )
    end

    # Internal: Create a new Topic from this Adapter
    #
    # name - the name of this Topic
    #
    # Returns a Qup::Topic
    def topic( name )
      Qup::Adapter::Kestrel::Topic.new( @client, name )
    end

    # Internal: Close the Kestrel adapter
    #
    # Return nothing
    def close
      @client.disconnect
    end

    # Internal: Is the Kestrel Adapter closed
    #
    # Returns true or false
    def closed?
      not @client.connected?
    end
  end
end
require 'qup/adapter/kestrel/queue'
require 'qup/adapter/kestrel/topic'
