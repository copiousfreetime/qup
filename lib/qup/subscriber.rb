module Qup
  # Public: Receives Messages from a Topic
  #
  # All Subscribers to a Topic will receive each Message that is published to
  # the Topic.
  #
  class Subscriber < Consumer
    # Public: The name of this subscriber
    attr_reader :name

    # Public: Create a new Subscriber on a Topic
    #
    # Returns a Subscriber
    def initialize( topic, queue )
      super( queue )
      @topic = topic
      @name  = @queue.name
    end

    # Public: Remove the Subscriber from the Topic
    #
    # This just means to destroy the Queue that it is attached to
    #
    def unsubscribe
      @queue.destroy
    end
  end
end
