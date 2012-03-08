require 'spec_helper'

describe Qup::Message do
  before do
    @m = Qup::Message.new( "my unique key", "some data" )
  end

  it "has a key" do
    @m.key.must_equal 'my unique key' 
  end

  it 'has data' do
    @m.data.must_equal 'some data'
  end
end
