require 'qup/adapter/kestrel/destination'
class Qup::Adapter::Kestrel
  #
  # Public: A Topic for use in a publish-subscribe Messaging
  #
  # The topic delivers each Message that it is give to each and every Subscriber
  #
  class Topic < Destination
    include Qup::TopicAPI

    # Public: Creates a Publisher for the Topic
    #
    # Returns a new Publisher
    def publisher
      ::Qup::Publisher.new( self )
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
      ::Qup::Subscriber.new( self, subscriber_queue( name )  )
    end

    # Public: Return the number of Subscribers to this Topic
    #
    # Returns integer
    def subscriber_count
      c = 0
      puts @client.stats.inspect
      @client.stats['queues'].keys.each do |k|
        next if k =~ /errors$/
        c += 1 if k =~ /^#{@name}\+/
      end
      return c
    end

    # Internal: Publish a Message to all the Subscribers
    #
    # message - the Object to send to all subscribers
    #
    # Returns nothing
    def publish( message )
      @client.set( @name, message )
    end

    #######
    private
    #######
    #
    def subscriber_queue_name( sub_name )
      "#{@name}+#{sub_name}"
    end

    def subscriber_queue( sub_name )
      sname = subscriber_queue_name( sub_name )
      ::Qup::Adapter::Kestrel::Queue.new( @addr, sname )
    end
  end
end
