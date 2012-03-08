require 'spec_helper'

describe Qup::Message do
  let( :message ) { Qup::Message.new( "my unique key", "some data" ) }

  it "has a key" do
    message.key.should == 'my unique key'
  end

  it 'has data' do
    message.data.should == 'some data'
  end
end
