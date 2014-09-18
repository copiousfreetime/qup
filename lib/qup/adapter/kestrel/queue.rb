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
    def initialize( client, name )
      super( client, name )
      @open_messages = {}
    end

    # Internal: The name of the Queue
    attr_reader :name

    # Internal: Remove all messages from the Queue
    #
    # Returns nothing.
    def flush
      @client.flush(@name)
    end

    # Internal: Remove the Queue if possible
    #
    # Returns nothing
    def destroy
      @client.delete(@name)
    end

    # Internal: return the number of Messages on the Queue
    #
    # Returns an integer of the Queue depth
    def depth
      @client.stats['queues'][@name]['items']
    end


    # Internal: Put an item onto the Queue
    #
    # message - the data to put onto the queue.
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
    # Returns a Message or nil if no message was on the queue
    def consume(&block)
      q_item = @client.reserve( @name )
      return nil unless valid(q_item)
      q_message = ::Qup::Message.new( q_item.object_id, unmarshal_if_marshalled( q_item ))
      @open_messages[q_message.key] = q_item
      if block_given? then
        yield_message( q_message, &block )
      end
      return q_message
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
      @client.close( @name )
    end

    #######
    private
    #######

    def valid(data)
      return data && data[0] && data[1]
    end

    def unmarshal_if_marshalled( data )
      if data[0].ord == 4 and data[1].ord == 8 then
        Marshal::load( data )
      else
        data
      end
    end


    def yield_message( message, &block )
      yield message
    ensure
      acknowledge( message )
    end
  end
end
