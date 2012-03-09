require 'qup/adapter'
require 'kestrel-client'

class Qup::Adapter
  # Internal: The backing adapter for Qup that uses Maildir as a the messaging
  # infrastructure
  class Kestrel < ::Qup::Adapter

    # Register this adapter as :maildir
    register :kestrel

    # Internal: Create a new Maildir Adapter
    #
    # uri - the URI instance for this adapter to use
    def initialize( uri, options = {} )
      @uri        = uri
      @connection = nil
      @options    = options
      @closed     = false
    end

    # Internal: Create a new Queue from this Adapter
    #
    # name - the String name of the Queue
    #
    # Returns a Qup::Queue
    def queue( name )
      #Qup::Adapter::Kestrel::Queue.new( @connection, name )
    end

    # Internal: Create a new Topic from this Adapter
    #
    # name - the name of this Topic
    #
    # Returns a Qup::Topic
    def topic( name )
      #Qup::Adapter::Kestrel::Topic.new( @connection, name )
    end

    # Internal: Close the Maildir adapter
    #
    # Return nothing
    def close
      @closed = true
    end

    # Internal: Is the Maildir Adapter closed
    #
    # Returns true or false
    def closed?
      @closed
    end
  end
end
