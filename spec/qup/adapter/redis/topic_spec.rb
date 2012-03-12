require 'spec_helper'
require 'qup/shared_topic_examples'
require 'qup/adapter/redis_context'

describe 'Qup::Adapter::Redis::Topic', :redis => true  do
  include_context "Qup::Adapter::Redis"
  include_context "Qup::Topic"
  it_behaves_like Qup::TopicAPI
end
