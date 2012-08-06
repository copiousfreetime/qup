require 'thrift_client'
require 'qup/adapter/kestrel/thrift'
class Qup::Adapter::Kestrel
  #
  # Internal: The Common base class for Kestrel Topic and Queue
  #
  class Destination
    # Thrift client options
    DEFAULTS = { :transport_wrapper => ::Thrift::FramedTransport }
    DEFAULT_ITEM_TIMEOUT_MSEC = 60_000

    # Internal: the name of the Queue or Topic
    attr_reader :name

    # Utility method to return an array given either an array or scalar
    def self.wrap(array_or_scalar)
      array_or_scalar.is_a?(Array) ? array_or_scalar : [ array_or_scalar ]
    end

    # Internal: Create a new Topic or Queue
    #
    # address - the Connection Address string for the Kestrel Client
    # name    - the String name of the Topic or Queue
    #
    # Returns a new Topic or Queue.
    def initialize( address, name, stats_address )
      @address       = address
      @stats_address = stats_address
      @servers       = [ @address ]
      @client        = ::ThriftClient.new( Qup::Adapter::Kestrel::Thrift::Kestrel::Client, @servers, DEFAULTS )
      @name          = name
      ping
    end

    # Internal: Destroy the Topic or Queue
    #
    # If possible remove the existence of the Topic from the System
    #
    # Returns nothing.
    def destroy
      @client.delete_queue( name )
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
