require 'json'
require 'set'
require 'qup/adapter/kestrel/destination'
class Qup::Adapter::Kestrel
  #
  # Internal: The Topic implementation for the Kestrel Adapter
  #
  # The topic delivers each Message that it is give to each and every Subscriber
  #
  class Topic < Destination
    include Qup::TopicAPI

    # Internal : Creates a Publisher for the Topic
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
      ::Qup::Subscriber.new( self, subscriber_queue( name )  )
    end


    # Internal: Return the number of Subscribers to this Topic
    #
    # We want the sub portion of the json document that is in the 'counters'
    # section. The keys in the 'counters' section that represent queue counters
    # are all prefixed with 'q/<queue_name>/<stat>'. To count the number of
    # subscribers to this topic, we just count the uniqe <queue_name> elements
    # that start with this queue's name and followed by a '+'
    #
    # Returns integer
    def subscriber_count
      c = Set.new

      stats['queues'].keys.each do |k|
        next unless k =~ %r{\A#{@name}\+}
        parts = k.split("+")
        c << parts[1]
      end

      return c.size
    end

    # Internal: Publish a Message to all the Subscribers
    #
    # message - the Object to send to all subscribers
    #
    # Returns nothing
    def publish( message )
      @client.set( @name,  message ) # do not expire the message
    end

    #######
    private
    #######

    def subscriber_queue( sub_name )
      sname = subscriber_queue_name( sub_name )
      ::Qup::Adapter::Kestrel::Queue.new( @client, sname )
    end

    def subscriber_queue_name( sub_name )
      "#{@name}+#{sub_name}"
    end

    def stats
      @client.stats
    end
  end
end
