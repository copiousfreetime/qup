require 'spec_helper'

describe Qup::Adapter::Maildir::Topic do

  let( :path  ) { temp_dir( "qup-topic" ) }

  before do
    @topic = ::Qup::Adapter::Maildir::Topic.new( path, 't' )
  end

  after do
    FileUtils.rm_rf( path )
  end

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
    p.topic.should == @topic
  end

  it "sends a copy of the message to every subscriber" do
    s1 = @topic.subscriber( 's1' )
    s2 = @topic.subscriber( 's2' )
    p  = @topic.publisher

    p.publish( "hi all" )
    m1 = s1.consume
    m1.data.should == "hi all"

    m2 = s2.consume
    m2.data.should == "hi all"
  end

end
