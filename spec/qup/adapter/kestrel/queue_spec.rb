require 'spec_helper'
require 'qup/shared_queue_examples'
require 'qup/adapter/kestrel_context'

describe 'Qup::Adapter::Kestrel::Queue', :kestrel => true do
  include_context "Qup::Adapter::Kestrel"
  include_context "Qup::Queue"
  it_behaves_like Qup::QueueAPI

  it "sets client options in the queue" do
    Qup::Session.new(uri.to_s, :client => {:the => "OPTION"}).queue("test-queue").instance_variable_get("@client").instance_variable_get("@options")[:the].should == "OPTION"
  end

  it "sets client options in the topic" do
    Qup::Session.new(uri.to_s, :client => {:the => "OPTION"}).topic("test-queue").instance_variable_get("@client").instance_variable_get("@options")[:the].should == "OPTION"
  end
end
