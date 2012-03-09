require 'qup/producer'
require 'qup/consumer'
module Qup
  #
  # Public: A QueueAPI for use in a point-to-point messaging pattern.
  #
  # The Queue guarantees that each Message that is on the Queue is delivered and
  # acknowledged only once.
  #
  # A very common pattern for Queue usage is a worker pattern where you have a
  # Producer putting job Messages on the Queue and a collection of Consumers
  # which work on those job Messages.
  #
  # This is the API that MUST be impelemnted in the adapter.
  #
  # Example:
  #
  #   session = Session.new( uri )
  #   queue = session.queue( 'my_queue' )
  #
  #   queue.producer  # => Producer
  #   queue.consumer  # => Consumer
  #   queue.depth     # => 4
  #
  module QueueAPI

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


    #--------------------------------------------------------------------------
    # The API that Adapters must implement
    #--------------------------------------------------------------------------

    # Public: the name of the Queue
    #
    # Returs the String name
    def name
      super
    rescue NoMethodError
      raise NotImplementedError, "please implement 'name'"
    end


    # Public: return the number of Messages on the Queue
    #
    # Returns an integer of the Queue depth
    def depth
      raise NotImplementedError, "please implement 'depth'"
    end


    # Public: empty all the messages from the Queue, this does not consume them,
    # this removes the from the Queue
    #
    # Returns nothing
    def flush
      raise NotImplementedError, "please implement 'flush'"
    end


    # Public: destroy the Queue if possible
    #
    # This will clear the Queue and remove it from the system if possible
    #
    # Returns nothing.
    def destroy
      super
    rescue NoMethodError
      raise NotImplementedError, "please implement 'destroy'"
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
      raise NotImplementedError, "please implement 'produce'"
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
      raise NotImplementedError, "please implement 'consume'"
    end


    # Internal: Acknowledge that message is completed and remove it from the
    # Queue.
    #
    # Returns nothing
    def acknowledge( message )
      raise NotImplementedError, "please implement 'acknowledge'"
    end

  end
end
