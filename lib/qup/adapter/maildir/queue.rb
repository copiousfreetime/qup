require 'qup/producer'
require 'qup/consumer'

class Qup::Adapter::Maildir
  #
  # Internal: The Qup Implementation in the Maildir Adapter
  #
  class Queue
    include Qup::QueueAPI
    # Internal: the name of the Queue
    attr_reader :name

    # Internal: Create a new Queue
    #
    # root_path - the root_path for this Queue to create under
    # name      - the String name of the Queue
    #
    # Returns a new Queue.
    def initialize( root_path, name )
      @root_path  = ::Pathname.new( root_path )
      @name       = name
      @queue_path = @root_path + @name
      @maildir    = ::Maildir.new( @queue_path, true )
      # FIXME: this is a -w for Maildir issue, remove when fixed upstream
      @maildir.serializer = ::Maildir::Serializer::Base.new
    end


    # Internal: Remove the Queue from the system
    #
    # Returns nothing.
    def destroy
      @queue_path.rmtree
    end


    # Internal: Remove all messages from the Queue
    #
    # Returns nothing.
    def flush
      ::Maildir::SUBDIRS.each do |sub|
        dir = Pathname.new( File.join( @maildir.path, sub.to_s ))
        dir.children.each do |p|
          p.delete if p.file?
        end
      end
    end


    # Internal: return the number of Messages on the Queue
    #
    # Returns an integer of the Queue depth
    def depth
      total = 0
      %w[ new cur ].each do |subdir|
        search_path = File.join( @maildir.path, subdir, '*' )
        keys = Dir.glob( search_path )
        total += keys.size
      end
      return total
    end


    # Internal: Put an item onto the Queue
    #
    # message - the data to put onto the queue.
    #
    # The 'message' that is passed in is wrapped in a Qup::Message before being
    # stored.
    #
    # A user of the Qup API should use a Producer instance to put items onto the
    # queue.
    #
    # Returns the Message that was put onto the Queue
    def produce( message )
      msg = @maildir.add( message )
      return ::Qup::Message.new( msg.key, msg.data )
    end


    # Internal: Retrieve a Message from the Queue
    #
    # Yields a Message
    #
    # A user of the Qup API should use a Consumer instance to retrieve items
    # from the Queue.
    #
    # Returns a Message
    def consume(&block)
      msg = @maildir.list(:new, :limit => 1).first
      return nil if msg.nil?
      msg.process
      msg.seen!
      q_message = ::Qup::Message.new( msg.key, msg.data )
      if block_given? then
        yield_message( q_message, &block )
      else
        return q_message
      end
    end


    # Internal: Acknowledge that message is completed and remove it from the
    # Queue.
    #
    # Returns nothing
    def acknowledge( message )
      md_message = @maildir.get( message.key )
      msg = "Message #{message.key} has not been processed yet"
      raise ::Qup::Error, msg unless md_message.dir == :cur
      raise ::Qup::Error, msg unless md_message.seen?
      md_message.destroy
    end

    #######
    private
    #######

    def yield_message( message, &block )
      yield message
    ensure
      acknowledge( message )
    end
  end
end
