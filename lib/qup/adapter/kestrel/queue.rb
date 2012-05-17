require 'qup/adapter/kestrel/destination'

class Qup::Adapter::Kestrel
  #
  # Internal: The Implementation of Queue in the Kestrel Adapter
  #
  class Queue < Destination
    include Qup::QueueAPI

    # Internal: Create a new Queue
    #
    # address - the Connection Address string for the Kestrel Client
    # name    - the String name of the Topic
    #
    # Returns a new Queue
    def initialize( address, name, stats_address )
      super(address, name, stats_address )
      @open_messages = {}
    end

    # Internal: The name of the Queue
    attr_reader :name

    # Internal: Remove all messages from the Queue
    #
    # Returns nothing.
    def flush
      @client.flush_queue(@name)
    end


    # Internal: return the number of Messages on the Queue
    #
    # Returns an integer of the Queue depth
    def depth
      queue_info = @client.peek( @name )
      return queue_info.items
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
      @client.put( @name, Array( message ), 0 ) # do not expire the message
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
      # queue name, max_items( 1 ), timeout_mse (10 seconds ), auto_abort_msec (16 minutes)
      msg_list  = @client.get( @name, 1, 10_000, 1_000_000 )
      q_item    = msg_list.first
      q_message = ::Qup::Message.new( q_item.id, q_item.data )
      @open_messages[q_message.key] = q_item
      if block_given? then
        yield_message( q_message, &block )
      else
        return q_message
      end
    end


    # Internal: Acknowledge that message is completed and remove it from the
    # Queue.
    #
    # For Kestrel, this really just closes the last message, the message that is
    # sent in does not matter.
    #
    # Returns nothing
    def acknowledge( message )
      open_msg = @open_messages.delete( message.key )
      raise Qup::Error, "Message #{message.key} is not currently being consumed" unless open_msg
      @client.confirm( @name, Array( message.key )  )
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
