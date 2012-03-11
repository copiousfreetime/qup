module Qup
  # The Current Version of the library
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

  KNOWN_ADAPTERS = {
    # require => gem
    'maildir' => 'maildir',
    'kestrel' => 'kestrel-client'
  }
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

# Load the known adapters, print a warning if $VERBOSE is set
Qup::KNOWN_ADAPTERS.each do |adapter, gemname|
  begin
    require "qup/adapter/#{adapter}"
  rescue LoadError
    warn "Install the '#{gemname}' gem of you want to use the #{adapter} adapter" if $VERBOSE
  end
end
