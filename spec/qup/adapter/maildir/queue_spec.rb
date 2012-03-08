require 'spec_helper'

describe Qup::Adapter::Maildir::Queue do

  let( :path    ) { temp_dir( "qup-queue" )            }
  let( :uri     ) { URI.parse( "maildir://#{path}" )   }
  let( :adapter ) { ::Qup::Adapter::Maildir.new( uri ) }

  let( :queue ) { adapter.queue( 'foo' ) }

  after do
    queue.destroy
  end

  it "has a name" do
    queue.name.should eq 'foo'

    dirname = File.join( path, 'foo' )
    File.directory?( dirname ).should be_true
  end

  it "can have a message added to it" do
    queue.depth.should eq 0
    queue.produce( "a new message" )
    queue.depth.should eq 1
  end

  it "can have a message consumed" do
    queue.produce( "consumeable message" )
    queue.depth.should eq 1

    msg = queue.consume
    msg.data.should eq "consumeable message"
    queue.depth.should eq 1
  end

  it "can acknowledge a consumed message" do
    queue.produce( "acknowledgeable message" )
    queue.depth.should eq 1

    msg = queue.consume
    msg.data.should eq "acknowledgeable message"
    queue.depth.should eq 1

    queue.acknowledge( msg )
    queue.depth.should eq 0
  end

  it "raises an error if you attemp to to acknowledg an unconsumed message" do
    msg = queue.produce( 'unconsumed' )
    lambda { queue.acknowledge( msg ) }.should raise_error(Qup::Error)
  end
end
