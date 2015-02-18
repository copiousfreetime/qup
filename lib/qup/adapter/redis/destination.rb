class Qup::Adapter::Redis
  #
  # Internal: The Common base class for Redis Topic and Queue
  #
  class Destination

    # Public: the name of the Queue or Topic
    attr_reader :name

    # Public: Create a new Connection
    #
    # uri  - the connection uri for the Redis Client
    # name - the String name of the Connection
    #
    # Returns a new Connection.
    def initialize( client, name )
      @client = client
      @name   = name
      ping
    end

    # Internal: Make sure the Topic or Queue exists
    #
    # Returns nothing
    def ping
      @client.ping
      return true
    end

  end
end
