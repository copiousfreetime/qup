class Qup
  VERSION = '1.0.0'

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
  def connect( uri, &block )
  end

end
