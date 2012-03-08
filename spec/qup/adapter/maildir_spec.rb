require 'spec_helper'
require 'qup/shared_adapter_examples'

describe Qup::Adapter::Maildir::Queue do

  let( :path    ) { temp_dir( "qup-queue" )            }
  let( :uri     ) { URI.parse( "maildir://#{path}" )   }

  # Needed to support the Shared Examples
  let( :adapter ) { ::Qup::Adapter::Maildir.new( uri ) }

  it_behaves_like ::Qup::Adapter
end
