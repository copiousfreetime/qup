class Qup::Adapter::Kestrel
  #
  # Internal: The Common base class for Kestrel Topic and Queue
  #
  class Destination

    # Public: the name of the Queue or Topic
    attr_reader :name

    # Public: Create a new Topic
    #
    # address - the Connection Adddress string for the Kestrel Client
    # name    - the String name of the Topic
    #
    # Returns a new Topic.
    def initialize( address, name )
      @client = blocking_transactional_client( address )
      @name   = name
    end

    # Public: Destroy the Topic
    #
    # If possible remove the existence of the Topic from the System
    #
    # Returns nothing.
    def destroy
      @client.delete( @name )
    end

    #######
    private
    #######

    def regular_client( addr )
      Kestrel::Client.new( addr )
    end

    def blocking_transactional_client( addr )
      Kestrel::Client::Blocking.new( Kestrel::Client::Transactional.new( regular_client(addr) ) )
    end
  end
end
