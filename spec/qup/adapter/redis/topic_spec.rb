require 'spec_helper'
require 'qup/shared_topic_examples'
require 'qup/adapter/redis_context'

describe 'Qup::Adapter::Redis::Topic', :redis => true  do
  include_context "Qup::Adapter::Redis"
  include_context "Qup::Topic"
  it_behaves_like Qup::TopicAPI

  describe "#subscriber" do

    let(:topic)      { adapter.topic "test" }
    let(:subscriber) { topic.subscriber "testing" }

    before do
      topic && subscriber # create and register the subscriber
    end

    after do
      topic.destroy
    end

    it "unregisters itself from the Topic when unsubscribed" do
      lambda do
        subscriber.unsubscribe
      end.should change(topic, :subscriber_count).by(-1)
    end
  end
end
