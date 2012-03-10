require 'spec_helper'

# The Adapter share context requires that the context is include in define:
#
#   let( :adapter )
#
shared_examples Qup::Adapter do
  it 'is registered as an adapter' do
    Qup::Adapters[uri.scheme].should eq adapter.class
  end

  it 'can be closed' do
    adapter.closed?.should be_false
    adapter.close
    adapter.closed?.should be_true
  end

  it 'can create a QueueAPI-like object' do
    q = adapter.queue( 'q' )
    q.should be_kind_of( Qup::QueueAPI )
    q.name.should eq 'q'
  end

  it 'can create a QueueAPI-like object' do
    t = adapter.topic( 't' )
    t.should be_kind_of( Qup::TopicAPI )
    t.name.should eq 't'
  end
end
