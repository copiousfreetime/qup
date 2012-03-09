require 'qup/adapter/kestrel/destination'

class Qup::Adapter::Kestrel
  #
  # Internal: The Qup Implementation in the Kestrel Adapter
  #
  class Queue < Destination
    include Qup::QueueAPI

    # Public: The name of the Queue
    attr_reader :name

    # Internal: Remove all messages from the Queue
    #
    # Returns nothing.
    def flush
      @admin_client.flush(@name)
    end


    # Internal: return the number of Messages on the Queue
    #
    # Returns an integer of the Queue depth
    def depth
      @admin_client.stat(@name)['items']
    end


    # Internal: Put an item onto the Queue
    #
    # message - the data to put onto the queue.
    #
    # The 'message' that is passed in is wrapped in a Qup::Message before being
    # stored.
    #
    # A user of the Qup API should use a Producer instance to put items onto the
    # queue.
    #
    # Returns the Message that was put onto the Queue
    def produce( message )
      @client.set( @name, message )
      return ::Qup::Message.new( message.object_id, message )
    end


    # Internal: Retrieve a Message from the Queue
    #
    # Yields a Message
    #
    # A user of the Qup API should use a Consumer instance to retrieve items
    # from the Queue.
    #
    # Returns a Message
    def consume(&block)
      data = @client.get( @name )
      q_message = ::Qup::Message.new( data.object_id, data )
      if block_given? then
        yield_message( q_message, &block )
      else
        return q_message
      end
    end


    # Internal: Acknowledge that message is completed and remove it from the
    # Queue.
    #
    # For Kestrel, this really just close the lastmessage, the message that is
    # sent in does not matter.
    #
    # Returns nothing
    def acknowledge( message )
      @client.close_last_transaction
    end

    #######
    private
    #######

    def yield_message( message, &block )
      yield message
    ensure
      acknowledge( message )
    end
  end
end
