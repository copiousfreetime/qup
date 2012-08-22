module Qup
  module DrainerAPI
    def setup
    end

    def process(message)
      raise NotImplementedError
    end

    def teardown
    end
  end

  class Drainer

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
