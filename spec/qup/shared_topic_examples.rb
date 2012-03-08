require 'spec_helper'

# The Queue share contxt requires that the context is include in define:
#
#   let( :adapter )
#
shared_context "::Qup::Topic Context" do
  let( :adapter ) { ::Qup::Adapter::Maildir.new( uri ) }

  before do
    @topic = adapter.topic( 't' )
  end

  after do
    @topic.destroy
  end
end


shared_examples ::Qup::TopicAPI do

  it "has a name" do
    @topic.name.should == 't'
  end

  it "creates the base directory if it doesn't exist" do
    File.directory?( File.join( path, 't' )).should be_true
  end

  it "creates subscribers" do
    @topic.subscriber_count.should eq 0
    3.times { |x| @topic.subscriber( x.to_s ) }
    @topic.subscriber_count.should eq 3
  end

  it "creates publisher" do
    p = @topic.publisher
    p.topic.should eq @topic
  end

  it "sends a copy of the message to every subscriber" do
    s1 = @topic.subscriber( 's1' )
    s2 = @topic.subscriber( 's2' )
    p  = @topic.publisher

    p.publish( "hi all" )
    m1 = s1.consume
    m1.data.should eq "hi all"

    m2 = s2.consume
    m2.data.should eq "hi all"
  end
end
