require 'spec_helper'

describe Qup::Producer do
  before do
    @path  = temp_dir( "qup-producer" )
    @queue = ::Qup::Queue.new( @path, 'bar' )
    p = @queue.producer
    p.produce( 'consumption' )
    @consumer = @queue.consumer
  end

  after do
    FileUtils.rm_rf( @path )
  end

  it "consumes an item from the queue" do
    msg = @consumer.consume
    msg.data.should eq 'consumption'
    @queue.acknowledge msg
    @queue.depth.should eq 0
  end

  it "consumes auto-acknowledges msgs in a block" do
    @consumer.consume do |msg|
      msg.data.should eq 'consumption'
    end
    @queue.depth.should eq 0
  end
end
