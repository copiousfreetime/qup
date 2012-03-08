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
    @queue.depth.should eq 0
    p.produce( 'production' )
    @queue.depth.should eq 1
  end
end
