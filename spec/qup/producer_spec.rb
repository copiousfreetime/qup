require 'spec_helper'

describe Qup::Producer do
  before do
    @path  = temp_dir( "qup-producer" )
    @queue = ::Qup::Queue.new( @path, 'bar' )
  end

  after do
    FileUtils.rm_rf( @path )
  end

  it "produces items onto the queue" do
    p = @queue.producer
    @queue.depth.must_equal 0
    p.produce( 'production' )
    @queue.depth.must_equal 1
  end
end
