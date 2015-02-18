require 'spec_helper'

# The Adapter share context requires that the context is include in define:
#
#   let( :adapter )
#
shared_examples Qup::Adapter do
  it 'is registered as an adapter' do
    expect( Qup::Adapters[uri.scheme] ).to eq adapter.class
  end

  it 'can be closed' do
    expect( adapter.closed? ).to be_falsey
    adapter.close
    expect( adapter.closed? ).to be_truthy
  end

  it 'can create a QueueAPI-like object' do
    q = adapter.queue( 'q' )
    expect( q ).to be_kind_of( Qup::QueueAPI )
    expect( q.name ).to eq 'q'
    q.destroy
  end

  it 'can create a QueueAPI-like object' do
    t = adapter.topic( 't' )
    expect( t ).to be_kind_of( Qup::TopicAPI )
    expect( t.name ).to eq 't'
    t.destroy
  end
end
