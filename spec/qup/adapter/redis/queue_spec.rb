require 'spec_helper'
require 'qup/shared_queue_examples'
require 'qup/adapter/redis_context'

describe 'Qup::Adapter::Redis::Queue', :redis => true do
  include_context "Qup::Adapter::Redis"
  include_context "Qup::Queue"
  it_behaves_like Qup::QueueAPI

  context "when initialized with a parent topic's name" do
    let(:redis) { Redis.new :host => uri.host, :port => uri.port }
    let(:queue) { Qup::Adapter::Redis::Queue.new(uri, "test", "parent") }

    before do
      redis.del "parent"
      redis.sadd "parent", "test"
    end

    after do
      redis.del "parent"
      redis.client.disconnect
    end

    describe "#destroy" do
      it "removes its name from the parent topic's subscriber set" do
        redis.smembers("parent").should == ["test"]
        queue.destroy
        redis.smembers("parent").should == []
      end
    end

  end
end
