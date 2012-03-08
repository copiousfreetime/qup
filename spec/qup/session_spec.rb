require 'spec_helper'

describe Qup::Session do
  before do
    @path    = temp_dir( "qup-session" )
    @session = Qup::Session.new( "maildir://#{@path}" )
  end

  after do
    FileUtils.rm_rf( @path )
  end

  it "has a uri" do
    @session.uri.to_s.should == "maildir:#{@path}"
  end

  it "can create a Queue" do
    q = @session.queue( 'foo' )
    q.name.should == 'foo'
  end
end
