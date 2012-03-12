require 'spec_helper'
require 'qup/shared_adapter_examples'
require 'qup/adapter/redis_context'

describe 'Qup::Adapter::Redis', :redis => true do
  include_context "Qup::Adapter::Redis"
  it_behaves_like Qup::Adapter
end
