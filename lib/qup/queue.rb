require 'maildir'
require 'qup/producer'
require 'qup/consumer'
module Qup
  #
  # Public: A Queue for use in a point-to-point messaging pattern.
  #
  # The Queue guarantees that each Message that is on the Queue is delivered and
  # acknowledged only once.
  #
  # A very common pattern for Queue usage is a worker pattern where you have a
  # Producer putting job Messages on the Queue and a collection of Consumers
  # which work on those job Messages.
  #
  class Queue
    # Public: the name of the Queue
    attr_reader :name

    # Public: Create a new Queue
    #
    # root_path - the Session this Queue is attached to
    # name      - the String name of the Queue
    #
    # Returns a new Queue.
    def initialize( root_path, name )
      @root_path = Pathname.new( root_path )
      @name      = name
      @maildir   = ::Maildir.new( @root_path + @name, true )
    end

    # Public: create a Producer for this Queue
    #
    # Returns a new Producer
    def producer
      Producer.new( self )
    end

    # Public: create a Consumer for this Queue
    #
    # Returns a new Consumer
    def consumer
      Consumer.new( self )
    end


    # Public: return the number of Messages on the Queue
    #
    # Returns an integer of the Queue depth
    def depth
      total = 0
      %w[ new cur ].each do |subdir|
        search_path = File.join( @maildir.path, subdir, '*' )
        keys = Dir.glob( search_path )
        total += keys.size
      end
      return total
    end

    # Internal: Put an item onto the Queue
    #
    # message - the data to put onto the queue
    #
    # A user of the Qup API should use a Producer instance to put items onto the
    # queue.
    #
    # Returns the Message that was put onto the Queue
    def produce( message )
      msg = @maildir.add( message )
      return Qup::Message.new( msg.key, msg.data )
    end

    # Internal: Retrieve an item from the Queue
    #
    # options - a Hash of options determining how long to wait for a Message
    #           :block   - should we block until a Message is available
    #                      (default: true )
    #           :timeout - how long to wait for a Message, only valid if
    #                      :block is false
    #
    # A user of the Qup API should use a Consumer instance to retrieve items
    # from the Queue.
    #
    # Returns a Message
    def consume(&block)
      msg = @maildir.list(:new, :limit => 1).first
      return nil if msg.nil?
      msg.process
      msg.seen!
      q_message = Qup::Message.new( msg.key, msg.data )
      if block_given? then
        yield_message( q_message, &block )
      else
        return q_message
      end
    end

    # Internal: Acknowledge that message is completed and remove it from the
    # Queue.
    #
    # Returns nothing
    def acknowledge( message )
      md_message = @maildir.get( message.key )
      msg = "Message #{message.key} has not been processed yet"
      raise Qup::Error, msg unless md_message.dir == :cur
      raise Qup::Error, msg unless md_message.seen?
      md_message.destroy
    end

    private

    def yield_message( message, &block )
      yield message
    ensure
      acknowledge( message )
    end
  end
end
