# BatchConsumer makes it easy to implement a batch-oriented consumer pattern
# by calling the appropriate hooks on the provided "client" class. Clients
# have the following callbacks:
#
# setup - Optional. Called before the client begins receiving messages
#   (immediately after BatchConsumer#run is called).
# process - Required. Called with an instance of Qup::Message when a
#   message is removed from the queue. After process finishes the message is
#   acknowledged from the queue. process is not wrapped in any exception
#   handling, so exceptions raised in process will propagate through the
#   BatchConsumer and the message will not be acknowledged.
# teardown - Optional. Called after the client has received :max_size
#   messages OR :max_age has been exceeded.
#
# BatchConsumers should be only be run once. If you need to run again, create
# a new instance.
#
# See #initialize for the config options.
#
# Examples:
#
#   class FileDumper
#     include Qup::BatchConsumerAPI
#
#     def setup
#       @file = File.open("/my/file.txt")
#     end
#
#     def process(message)
#       @file.puts(message.data)
#     end
#
#     def teardown
#       @file.close
#     end
#   end
#
#   batch_consumer = Qup::BatchConsumer.new({
#     :max_size   => 5000,
#     :max_age    => 600,
#     :client     => FileDumper.new,
#     :queue_uri  => "maildir:///tmp/test-queue",
#     :queue_name => "my-queue"
#   })
#
#   batch_consumer.run # This blocks until there have been 5000 message OR 600 seconds have passed.
module Qup
  module BatchConsumerAPI
    def setup
    end

    def process(message)
      raise NotImplementedError
    end

    def teardown
    end
  end

  class BatchConsumer
    # options - A hash of configuration options.
    #          :client - The object upon which the callbacks are fired. It's class
    #                    should include Qup::BatchConsumerAPI for declarative
    #                    documentation purposes. Technically, the only constraint
    #                    is that this object implement #setup, #process and
    #                    #teardown (including Qup::BatchConsumerAPI includes noop
    #                    definitions for #setup and #teardown). Required.
    #          :queue_uri - The Qup format queue URI. Required.
    #          :queue_name - The name of the queue that messages will be consumed
    #                        from. Required.
    #          :max_size - The maximum number of messages to process. Optional.
    #          :max_age - The maximum number of seconds (from when #run is called)
    #                     before finishing. Note that :max_size and :max_age are
    #                     ORed, meaning that the BatchConsumer will finish when
    #                     the first constraint is met. If neither constraint is
    #                     provided, the BatchConsumer will never finish (i.e. #run
    #                     will block indefinitely). Optional.
    def initialize(config = {})
      @message_count = 0
      @config        = config
    end


    def run
      @start = Time.now
      client.setup

      while live?
        sleeper.tick
        consumer.consume do |message|
          client.process(message)
          @message_count += 1
          sleeper.reset
        end
      end

      client.teardown
    end

    private

    def client
      @config[:client]
    end

    def sleeper
      @sleeper ||= BackoffSleeper.new
    end

    def consumer
      @consumer ||= Qup::Session.new(@config[:queue_uri]).queue(@config[:queue_name]).consumer
    end

    def live?
      !too_big? && !too_old?
    end

    def too_big?
      @message_count >= @config[:max_size] if @config[:max_size]
    end

    def too_old?
      (Time.now - @start) > @config[:max_age] if @config[:max_age]
    end

  end
end
