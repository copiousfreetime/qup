require 'spec_helper'
require 'qup/shared_topic_examples'

describe Qup::Adapter::Maildir::Topic do

  let( :path    ) { temp_dir( "qup-topic" ) }
  let( :uri     ) { URI.parse( "maildir://#{path}" )   }

  # Needed to support the Shared Examples
  let( :adapter ) { ::Qup::Adapter::Maildir.new( uri ) }

  include_context "::Qup::Topic Context"
  it_behaves_like ::Qup::TopicAPI
end
