require 'uri'
require 'pathname'
module Qup
  # Public: Manage communicating with a provider
  #
  # Examples:
  #
  #   Session.new( 'maildir:///tmp/qup' )
  #   Session.new( 'kestrel://user:pass@host:port/' )
  #
  #   session.queue( 'foo' ) # => Queue
  #   session.topic( 'bar' ) # => Topic
  #
  # At the moment, a Session is not considered threadsafe, so each Thread should
  # create its own Session.
  class Session
    class ClosedError < Qup::Error; end

    # Public: The URI of this Session
    attr_reader :uri

    # Public: Create a new Session
    #
    # uri     - The connection String used to connectot to appropriate provider
    # options - The Hash of options that are passed to the underyling Adapter
    #
    # Returns a new Session
    def initialize( uri, options = {} )
      @uri       = URI.parse( uri )
      @root_path = Pathname.new( @uri.path )

      adapter_klass = Qup::Adapters[@uri.scheme]
      @adapter      = adapter_klass.new( @uri, options )

      @queues  = Hash.new
      @topics  = Hash.new
    end

    # Public: Allocate a new Queue
    #
    # Connect to an existing, or Create a new Queue with the given name and
    # options.
    #
    # Yields the Queue.
    #
    # name    - The String name of the Queue to connect/create
    # options - The Hash of options use to configure the Queue (default: {}).
    #           Currently not used.
    #
    # Returns a new Queue instance
    def queue( name, options = {}, &block )
      raise Qup::Session::ClosedError, "Session connected to #{@uri} is closed" if closed?
      q = (@queues[name] ||= @adapter.queue( name ))
      return q unless block_given?
      yield q
    end

    # Public: Allocate a new Topic
    #
    # Connect to an existing, or Create a new Topic with the given name and
    # options.
    #
    # Yields the Topic.
    #
    # name    - The String name of the Topic to connect/create
    # options - The Hash of options use to configure the Topic (defualt: {}).
    #           Currently not used.
    #
    # Returns a new Topic instance
    def topic( name, options = {}, &block )
      raise Qup::Session::ClosedError, "Session connected to #{@uri} is closed" if closed?
      t = (@topics[name] ||= @adapter.topic( name ) )
      return t unless block_given?
      yield t
    end

    # Public: Close the Session
    #
    # Calling closed on an already closed Session does nothing.
    #
    # Returns nothing
    def close
      @adapter.close
    end

    # Public: Is the Session closed?
    #
    # Returns true if the session is closed, false otherwise.
    def closed?
      @adapter.closed?
    end
  end
end
