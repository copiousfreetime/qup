require 'qup/adapter'
require 'maildir'

class Qup::Adapter
  # Internal: The backing adapter for Qup that uses Maildir as a the messaging
  # infrastructure
  class Maildir < ::Qup::Adapter

    # Register this adapter as :maildir
    register :maildir

    # Internal: Create a new Maildir Adapter
    #
    # uri - the URI instance for this adapter to use
    def initialize( uri, options = {} )
      @uri       = uri
      @options   = options
      @root_path = uri.path
      @closed    = false
    end

    # Internal: Create a new Queue from this Adapter
    #
    # name - the String name of the Queue
    #
    # Returns a Qup::Queue
    def queue( name )
      Qup::Adapter::Maildir::Queue.new( @root_path, name )
    end

    # Internal: Create a new Topic from this Adapter
    #
    # name - the name of this Topic
    #
    # Returns a Qup::Topic
    def topic( name )
      Qup::Adapter::Maildir::Topic.new( @root_path, name )
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

require 'qup/adapter/maildir/queue'
require 'qup/adapter/maildir/topic'
