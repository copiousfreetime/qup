class Qup::Adapter::Kestrel
  #
  # Internal: The Common base class for Kestrel Topic and Queue
  #
  class Destination
    # Internal: the name of the Queue or Topic
    attr_reader :name

    # Internal: Create a new Topic or Queue
    #
    # address - the Connection Address string for the Kestrel Client
    # name    - the String name of the Topic or Queue
    #
    # Returns a new Topic or Queue.
    def initialize( client, name )
      @client = client
      @name   = name
      ping
    end

    # Internal: Destroy the Topic or Queue
    #
    # If possible remove the existence of the Topic from the System
    #
    # Returns nothing.
    def destroy
      @client.delete( name )
    end

    # Internal: Make sure the Topic or Queue exists
    #
    # Returns nothing
    def ping
      @client.peek( name )
      return true
    end
  end
end
