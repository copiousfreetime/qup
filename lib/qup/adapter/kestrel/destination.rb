class Qup::Adapter::Kestrel
  #
  # Internal: The Common base class for Kestrel Topic and Queue
  #
  class Destination

    # Public: the name of the Queue or Topic
    attr_reader :name

    # Public: Create a new Topic or Queue
    #
    # address - the Connection Adddress string for the Kestrel Client
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

    # Public: Destroy the Topic
    #
    # If possible remove the existence of the Topic from the System
    #
    # Returns nothing.
    def destroy
      @admin_client.delete( name )
      @admin_client.delete( name+"_errors" )
    end

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
