require 'spec_helper'
require 'qup/shared_queue_examples'

describe Qup::Adapter::Kestrel::Queue do

  let( :uri     ) { URI.parse( "kestrel://localhost:22133" )   }

  # Needed to support the Shared Examples
  let( :adapter ) { ::Qup::Adapter::Maildir.new( uri ) }

  include_context "::Qup::Queue Context"
  it_behaves_like ::Qup::QueueAPI
end
