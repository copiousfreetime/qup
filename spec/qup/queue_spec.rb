require 'spec_helper'

describe Qup::Queue do
  before do
    @path  = temp_dir( "qup-queue" )
    @queue = ::Qup::Queue.new( @path, 'bar' )
  end

  after do
    FileUtils.rm_rf( @path )
  end

  it "has a name" do
    q = Qup::Queue.new( @path, 'foo' )
    q.name.must_equal 'foo'
    dirname = File.join( @path, 'foo' )
    File.directory?( dirname ).must_equal true
  end

  it "can have a message added to it" do
    @queue.depth.must_equal 0
    @queue.produce( "a new message" )
    @queue.depth.must_equal 1
  end

  it "can have a message consumed" do
    @queue.produce( "consumeable message" )
    @queue.depth.must_equal 1
    msg = @queue.consume
    msg.data.must_equal "consumeable message"
    @queue.depth.must_equal 1
  end

  it "can acknowledge a consumed message" do
    @queue.produce( "acknowledgeable message" )
    @queue.depth.must_equal 1
    msg = @queue.consume
    msg.data.must_equal "acknowledgeable message"
    @queue.depth.must_equal 1
    @queue.acknowledge( msg )
    @queue.depth.must_equal 0
  end

  it "raises an error if you attemp to to acknowledg an unconsumed message" do
    msg = @queue.produce( 'unconsumed' )
    lambda { @queue.acknowledge( msg ) }.must_raise Qup::Error
  end
end
