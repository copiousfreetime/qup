require 'spec_helper'
require 'qup/shared_queue_examples'
require 'qup/adapter/maildir_context'

describe 'Qup::Adapter::Maildir::Queue', :maildir => true do
  include_context "Qup::Adapter::Maildir"
  include_context "Qup::Queue"
  it_behaves_like Qup::QueueAPI
end
