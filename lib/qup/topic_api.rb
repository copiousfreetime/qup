module Qup
  #
  # Public: A TopicAPI for use in a publish-subscribe Messaging
  #
  # The Topic delivers each Message that it is give to each and every Subscriber
  #
  # This API MUST be implemented in each Adapter
  #
  # Example:
  #
  #   session = Qup::Session.new( uri )
  #   topic = session.topic( 'news' )
  #
  #   pub = topic.publisher
  #
  #   sub1 = topic.subscriber( 'sub1' )
  #   sub2 = topic.subscriber( 'sub2' )
  #
  #   pub.publish( 'some news' )
  #
  #   message1 = sub1.consume
  #   message2 = sub2.consume
  #
  module TopicAPI

    # Public: Creates a Publisher for the Topic
    #
    # Returns a new Publisher
    def publisher
      Publisher.new( self )
    end

    # Public: Create a subscriber for the Topic
    #
    # name - the String name of the subscriber
    #
    # Creating a subscriber creates a new Subscriber that will receive a copy of
    # every message that is published to the Topic.
    #
    # Subscribers are unique by name, two subscribers with the same name will
    # act as individual Consumers on a queue of their name.
    #
    # Returns a Subscriber
    def subscriber( name )
      Subscriber.new( self, name )
    end


    #--------------------------------------------------------------------------
    # The API that Adapters must implement
    #--------------------------------------------------------------------------

    # Public: the name of the Topic
    #
    # Returs the String name
    def name
      raise NotImplementedError, "please implement 'name'"
    end


    # Public: Return the number of Subscribers to this Topic
    #
    # Returns integer
    def subscriber_count
      raise NotImplementedError, "please implement 'subscriber_count'"
    end

    # Internal: Publish a Message to all the Subscribers
    #
    # message - the Object to send to all subscribers
    #
    # Returns nothing
    def publish( message )
      raise NotImplementedError, "please implement 'subscriber_count'"
    end
  end
end
