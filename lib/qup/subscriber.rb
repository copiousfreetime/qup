module Qup
  # Public: Receives Messages from a Topic
  #
  # All Subscribers to a Topic will receive each Message that is published to
  # the Topic.
  #
  class Subscriber < Consumer
    # Public: Create a new Subscriber on a Topic
    #
    # Returns a Subscriber
    def initialize( topic, queue )
      super( queue )
      @topic = topic
    end
  end
end
