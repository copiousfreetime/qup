module Qup
  # Public: Consumes items for a queue
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
    # Returns a Messaage
    def consume(&block)
      @queue.consume(&block)
    end
  end
end
