require 'spec_helper'
require 'qup/shared_queue_examples'
require 'qup/adapter/kestrel_context'

describe 'Qup::Adapter::Kestrel::Queue', :kestrel => true do
  include_context "Qup::Adapter::Kestrel"
  include_context "Qup::Queue"
  it_behaves_like Qup::QueueAPI
end
