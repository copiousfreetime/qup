class Qup::Adapter::Maildir
  #
  # Internal: A Topic for use in a publish-subscribe Messaging
  #
  # The topic delivers each Message that it is give to each and every Subscriber
  #
  class Topic
    include Qup::TopicAPI

    # Internal: the name of the Topic
    attr_reader :name

    # Internal: Create a new Topic
    #
    # root_path - the Session this Topic is attached to
    # name      - the String name of the Topic
    #
    # Returns a new Topic.
    def initialize( root_path, name )
      @root_path   = ::Pathname.new( root_path )
      @name        = name
      @topic_path  = @root_path + @name

      FileUtils.mkdir_p( @topic_path )
      @topic_path_mtime = @topic_path.mtime
    end

    # Internal: Destroy the Topic
    #
    # If possible remove the existence of the Topic from the System
    #
    # Returns nothing.
    def destroy
      @topic_path.rmtree if @topic_path.directory?
    end

    # Internal: Creates a Publisher for the Topic
    #
    # Returns a new Publisher
    def publisher
      ::Qup::Publisher.new( self )
    end

    # Internal: Create a subscriber for the Topic
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
      ::Qup::Subscriber.new( self, sub_queue( name )  )
    end

    # Internal: Return the number of Subscribers to this Topic
    #
    # Returns integer
    def subscriber_count
      subscribers.size
    end

    # Internal: Publish a Message to all the Subscribers
    #
    # message - the Object to send to all subscribers
    #
    # Returns nothing
    def publish( message )
      subscribers.each do |name, sub|
        sub.produce( message )
      end
    end

    #######
    private
    #######
   
    def subscribers
      subs = {}
      if @topic_path.directory? then
        @topic_path.each_child do |child|
          if child.directory?
            name = child.basename
            subs[name] = sub_queue( name )
          end
        end
      end
      return subs
    end 

    def sub_queue( name )
      ::Qup::Adapter::Maildir::Queue.new( @topic_path, name )
    end
  end
end
