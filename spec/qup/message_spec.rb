require 'spec_helper'

describe Qup::Message do
  before do
    @m = Qup::Message.new( "my unique key", "some data" )
  end

  it "has a key" do
    @m.key.should == 'my unique key' 
  end

  it 'has data' do
    @m.data.should == 'some data'
  end
end
