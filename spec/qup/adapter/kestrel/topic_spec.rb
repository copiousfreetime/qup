require 'spec_helper'
require 'qup/shared_topic_examples'

describe Qup::Adapter::Kestrel::Topic do

  let( :uri     ) { URI.parse( "kestrel://localhost:22133" )   }

  # Needed to support the Shared Examples
  let( :adapter ) { ::Qup::Adapter::Kestrel.new( uri ) }

  include_context "::Qup::Topic Context"
  it_behaves_like ::Qup::TopicAPI
end
