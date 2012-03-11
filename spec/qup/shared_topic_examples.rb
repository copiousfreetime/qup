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
      3.times do |x|
        @subs << @topic.subscriber( "sub-#{x}")
      end
    end

    after do
      @subs.each { |s| s.unsubscribe }
    end

    it "are counted" do
      @topic.subscriber_count.should eq 3
    end

    it "each receives a copy of the message" do
      p = @topic.publisher
      p.publish( "hi all" )

      @subs.each do |sub|
        msg = sub.consume
        msg.data.should eq 'hi all'
      end
    end
  end
end
