require 'spec_helper'

describe Qup::Producer do

  let( :path     ) { temp_dir( "qup-producer" )      }
  let( :queue    ) { ::Qup::Adapter::Maildir::Queue.new( path, 'baz' ) }
  let( :producer ) { queue.producer                  }

  after do
    FileUtils.rm_rf( path )
  end

  it "produces items onto the queue" do
    queue.depth.should eq 0
    producer.produce( 'production' )
    queue.depth.should eq 1
  end
end
