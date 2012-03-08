require 'spec_helper'

describe Qup::Consumer do

  let( :path     ) { temp_dir( "qup-consumer" )      }
  let( :queue    ) { ::Qup::Queue.new( path, 'bar' ) }
  let( :producer ) { queue.producer                  }
  let( :consumer ) { queue.consumer                  }

  before do
    producer.produce( 'consumption' )
  end

  after do
    FileUtils.rm_rf( path )
  end

  it "consumes an item from the queue" do
    msg = consumer.consume
    msg.data.should eq 'consumption'
    queue.acknowledge msg
    queue.depth.should eq 0
  end

  it "consumes auto-acknowledges msgs in a block" do
    consumer.consume do |msg|
      msg.data.should eq 'consumption'
    end
    queue.depth.should eq 0
  end
end
