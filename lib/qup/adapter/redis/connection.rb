class Qup::Adapter::Redis
  #
  # Internal: The Common base class for Redis Topic and Queue
  #
  class Connection

    # Public: the name of the Queue or Topic
    attr_reader :name

    # Public: Create a new Connection
    #
    # uri  - the connection uri for the Redis Client
    # name - the String name of the Connection
    #
    # Returns a new Connection.
    def initialize( uri, name )
      @uri    = uri
      @client = Redis.new :host => @uri.host, :port => @uri.port
      @name   = name
    end

    # Public: destroy the connection
    #
    # Closes the redis client connection.
    #
    # Returns nothing.
    def destroy
      @client.client.disconnect
    end

  end
end
