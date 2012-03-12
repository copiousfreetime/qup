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
    # name    - the String name of the Topic
    #
    # Returns a new Topic.
    def initialize( address, name )
      @address      = address
      @client       = blocking_transactional_client( @address )
      @admin_client = regular_client( @address )
      @name         = name
      ping
    end

    # Internal: Destroy the Topic or Queue
    #
    # If possible remove the existence of the Topic from the System
    #
    # Returns nothing.
    def destroy
      @admin_client.delete( name )
      @admin_client.delete( name+"_errors" )
    end

    # Internal: Make sure the Topic or Queue exists
    #
    # Returns nothing
    def ping
      @admin_client.peek( name )
      return true
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
