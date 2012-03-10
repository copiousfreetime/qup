require 'spec_helper'
require 'qup/shared_topic_examples'
require 'qup/adapter/maildir_context'

describe 'Qup::Adapter::Maildir::Topic', :maildir => true  do
  include_context "Qup::Adapter::Maildir"
  include_context "Qup::Topic"
  it_behaves_like Qup::TopicAPI
end
