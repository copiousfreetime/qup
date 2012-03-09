require 'spec_helper'
require 'qup/shared_adapter_examples'

describe Qup::Adapter::Kestrel do
  let( :uri     ) { URI.parse( "kestrel://localhost:22122/" )   }

  # Needed to support the Shared Examples
  let( :adapter ) { ::Qup::Adapter::Kestrel.new( uri ) }

  it_behaves_like ::Qup::Adapter
end
