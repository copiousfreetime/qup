require 'spec_helper'

describe Qup::Message do
  let( :message ) { Qup::Message.new( "my unique key", "some data" ) }

  it "has a key" do
    expect( message.key ).to eq 'my unique key'
  end

  it 'has data' do
    expect( message.data ).to eq 'some data'
  end
end
