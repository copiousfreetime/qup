module Qup
  # The known list of Adapters
  Adapters = Hash.new
  # Public: The module that Qup Adapters must extend
  #
  # Any backing system that implements the Qup API must have an entry point that
  # inherits from Adapter.
  class Adapter

    # Public: Register the child as an Adapter
    #
    # name - the name of the adapter. This will be the URI scheme value
    #
    # Return nothing
    def self.register( name )
      Adapters[name.to_s] ||= self
    end

    # Public: close the Adapter for further use
    #
    # Returns nothing
    def close
      raise NotImplementedError, "please implement 'close'"
    end

    # Public: is the Adapter closed
    #
    # Returns true or false
    def closed?
      raise NotImplementedError, "please implement 'closed?'"
    end
  end
end
