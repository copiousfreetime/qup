require 'spec_helper'

describe Qup::Consumer do

  let( :path     ) { temp_dir( "qup-consumer" )      }
  let( :queue    ) { ::Qup::Adapter::Maildir::Queue.new( path, 'bar' ) }
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
    expect( msg.data ).to eq 'consumption'
    queue.acknowledge msg
    expect( queue.depth ).to eq 0
  end

  it "acknowledges messages it has consumed" do
    msg = consumer.consume
    expect( msg.data ).to eq 'consumption'
    expect( queue.depth ).to eq 1
    consumer.acknowledge( msg )
    expect( queue.depth ).to eq 0
  end

  it "consumes auto-acknowledges msgs in a block" do
    consumer.consume do |msg|
      expect( msg.data ).to eq 'consumption'
    end
    expect( queue.depth ).to eq 0
  end

  it "knows how deep the consumer's queue is" do
    expect( consumer.depth ).to eq 1
    consumer.consume do |msg|
      expect( msg.data ).to eq 'consumption'
    end
    expect( queue.depth ).to eq 0
  end
end
