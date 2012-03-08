require 'spec_helper'

describe Qup::Producer do
  before do
    @path  = temp_dir( "qup-producer" )
    @queue = ::Qup::Queue.new( @path, 'bar' )
    p = @queue.producer
    p.produce( 'consumption' )
  end

  after do
    FileUtils.rm_rf( @path )
  end

  it "consumes an item from the queue" do
    msg = @queue.consume
    msg.data.must_equal 'consumption'
    @queue.acknowledge msg
    @queue.depth.must_equal 0
  end

  it "consumes auto-acknowledges msgs in a block" do
    @queue.consume do |msg|
      msg.data.must_equal 'consumption'
    end
    @queue.depth.must_equal 0
  end
end
