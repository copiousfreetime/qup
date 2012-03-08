module Qup
  # Public: Consumes items for a queue
  #
  # A Consumer is created from a Queue and consumes messages from the queue.
  #
  #
  class Consumer
    # Public: Create a new Consumer
    #
    # queue - the Queue this producer is for
    #
    # Returns a new Consumer
    def initialize( queue )
      @queue = queue
    end

    # Public: Consume a message for the queue
    #
    # Yields the message
    #
    # Most of the time you will want to call this message with a block as the
    # Message will be auto-acknowledged. If you do not consume messages with a
    # block, then you are required to acknowledge the messages on your own.
    #
    # Returns a Messaage
    def consume(&block)
      @queue.consume(&block)
    end
  end
end
