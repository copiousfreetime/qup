module Qup
  # Public: Produces items for a queue
  #
  # Examples:
  #
  #   producer = queue.producer
  #   producer.produce( my_message )
  #
  class Producer
    # Public: Create a new Producer
    #
    # queue - the Queue this producer is for
    #
    # Returns a new Producer
    def initialize( queue )
      @queue = queue
    end

    # Public: Produce a message for the queue
    #
    # message - the Object to put onto the queue
    #
    # Returns nothing.
    def produce( message )
      @queue.produce( message )
    end
  end
end
