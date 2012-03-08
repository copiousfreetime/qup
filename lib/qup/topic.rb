module Qup
  #
  # Public: A Topic for use in a publish-subscribe Messaging
  #
  # The topic delivers each Message that it is give to each and every Subscriber
  #
  class Topic

    # Public: the name of the Topic
    attr_reader :name

    # Public: Create a new Topic
    #
    # root_path - the Session this Topic is attached to
    # name      - the String name of the Topic
    #
    # Returns a new Topic.
    def initialize( root_path, name )
      @root_path   = Pathname.new( root_path )
      @name        = name
      @topic_path  = @root_path + @name
      @subscribers = Hash.new

      FileUtils.mkdir_p( @topic_path )

    end

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
      Subscriber.new( self, sub_queue( name )  )
    end

    # Public: Return the number of Subscribers to this Topic
    #
    # Returns integer
    def subscriber_count
      @subscribers.size
    end

    # Internal: Publish a Message to all the Subscribers
    #
    # message - the Object to send to all subscribers
    #
    # Returns nothing
    def publish( message )
      @subscribers.each do |name, sub|
        sub.produce( message )
      end
    end

    #######
    private
    #######

    def sub_queue( name )
      @subscribers[name] ||= ::Qup::Queue.new( @topic_path, name )
    end
  end
end
