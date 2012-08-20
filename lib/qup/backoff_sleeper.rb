# Used to sleep for exponentially increasing amounts of time between
# successive unsuccessful attempts to do something like poll for queue data or
# reconnect to a client. Maxes out at 1 second between attempts.
#
# Call #tick in every iteration of the task you are trying to accomplish. When
# a successful iteration is completed (for example the queue had data, or
# connecting was successful) call #reset to let the sleeper know that it can
# reset the amount of time between attempts back to 0. The sleeper will not
# call Kernel#sleep if it #reset was just called, so it is safe to call #tick
# on every iteration, provided that you call #reset on success before calling
# #tick.
#
# Examples:
#
#   sleeper = BackoffSleeper.new
#
#   loop do
#     message = check_for_message
#     sleeper.reset unless message.nil?
#     sleeper.tick
#   end
module Qup
  class BackoffSleeper
    attr_reader :count

    MULTIPLIERS = [0, 0.01, 0.1, 1]

    def initialize
      @count = 0
    end

    # Register an iteration. Sleeps if neccesary. Does not sleep if #reset has
    # just been called.
    def tick
      Kernel.sleep(length) if length > 0
      @count += 1
    end

    # Reset the backoff sequence to 0.
    def reset
      @count = 0
    end

    def length
      (multiplier + (multiplier * Kernel.rand)) / 2
    end

    def multiplier
      MULTIPLIERS[@count] || MULTIPLIERS.last
    end
  end
end
