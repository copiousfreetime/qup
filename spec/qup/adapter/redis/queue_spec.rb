require 'spec_helper'
require 'qup/shared_queue_examples'
require 'qup/adapter/redis_context'

describe 'Qup::Adapter::Redis::Queue', :redis => true do
  include_context "Qup::Adapter::Redis"
  include_context "Qup::Queue"
  it_behaves_like Qup::QueueAPI
end
