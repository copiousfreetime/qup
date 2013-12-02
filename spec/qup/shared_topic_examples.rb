require 'spec_helper'

# The Queue share context requires that the context is include in define:
#
#   let( :adapter )
#
shared_context "Qup::Topic" do

  before do
    @topic = adapter.topic( 'topic' )
  end

  after do
    @topic.destroy
  end
end


shared_examples Qup::TopicAPI do

  it "has a name" do
    @topic.name.should == 'topic'
  end

  it "creates publisher" do
    p = @topic.publisher
    p.topic.should eq @topic
  end


  describe "subscribers" do
    before do
      @subs = []
      @topic2 = adapter.topic( 'topic' )

      3.times do |x|
        @subs << @topic2.subscriber( "sub-#{x}")
      end
    end

    after do
      @topic2.destroy
      @topic.subscriber_count.should eq 0
    end

    it "updates the publisher with the number of subscribers" do
      start_count   = @topic.subscriber_count
      @topic2.subscriber_count.should eq start_count
      current_count = start_count

      3.times do |x|
        current_count += 1
        @topic2.subscriber( "sub2-#{x}" )
        puts "@topic subscriber_count  =>  #{@topic.subscriber_count}"
        puts "@topic2 subscriber count =>  #{@topic2.subscriber_count}"
        @topic.subscriber_count.should eq current_count
        @topic2.subscriber_count.should eq current_count
      end
    end

    it "each receives a copy of the message" do
      p = @topic.publisher
      p.publish( "hi all" )

      @subs.each do |sub|
        msg = sub.consume
        msg.data.should eq 'hi all'
      end
    end

    it "only receive a single message for a message containing newlines" do
      p = @topic.publisher
      p.publish( "one\nsingle\nmessage" )
      @subs.each do |sub|
        sub.depth.should eq 1
      end
    end
  end
end
