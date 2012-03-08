module Qup
  # Public: A Publisher produces messages on a Topic
  #
  class Publisher
    # Public: The Topic this Publisher publishes to.
    attr_reader :topic

    # Public: Create a new Publisher for a Topic
    #
    # Returns a Publisher
    def initialize( topic )
      @topic = topic
    end

    # Public: Publish a Message to all the Subscribers
    #
    # message - the Object to send to all Subscribers.
    #
    # Returns nothing
    def publish( message )
      @topic.publish( message )
    end
  end
end
