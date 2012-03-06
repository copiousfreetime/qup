module Qup
  #
  # Public: A Queue for use in a point-to-point messaging pattern.
  #
  # The Queue guarantees that each Message that is on the Queue is delivered and
  # acknowledged only once.
  #
  # A very common pattern for Queue usage is a worker pattern where you have a
  # Producer putting job Messages on the Queue and a collection of Consumers
  # which work on those job Messages.
  #
  class Queue
    def initialize( session, name )
      @session = session
      @name    = name
    end
  end
end
