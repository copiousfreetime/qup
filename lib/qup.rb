module Qup
  VERSION = '1.0.0'
  class Error < StandardError; end

  # Public: Connect to the given provider
  #
  # uri - the String representing the provider to talk to
  #
  # Yields the created Session. When the block returns, the session is closed
  #
  # Examples
  #
  #   session = Qup.connect( 'kestrel://localhost:22133' )
  #   session = Qup.connect( 'maildir:///tmp/qup' )
  #
  # Returns a Session.
  def self.connect( uri, &block )
  end
end

require 'qup/adapter'
require 'qup/consumer'
require 'qup/message'
require 'qup/producer'
require 'qup/publisher'
require 'qup/queue_api'
require 'qup/session'
require 'qup/subscriber'
require 'qup/topic_api'

require 'qup/adapter/maildir'
