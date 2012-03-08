module Qup
  # Public: A Message is an item that may be put on and taken off the queue.
  # 
  class Message

    # Public: The unique identifier of this messgae
    attr_reader :key

    # Public: The data in this Message
    attr_reader :data

    # Public: Create a Message from the given data
    def initialize( key, data )
      @key  = key
      @data = data
    end
  end
end
