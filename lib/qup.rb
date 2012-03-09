module Qup
  VERSION = '1.0.0'
  class Error < StandardError; end

  # Public: Create a new Session using the given provider URI
  #
  # uri - the String representing the provider to talk to
  #
  # Yields the created Session. When the block returns, the session is closed
  #
  # Examples
  #
  #   session = Qup.open( 'kestrel://localhost:22133' )
  #   session = Qup.open( 'maildir:///tmp/qup' )
  #
  # Returns a Session.
  def self.open( uri, &block )
    Qup::Session.open( uri, &block )
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
