require 'spec_helper'

describe Qup::Session do

  let( :path    ) { temp_dir( "qup-session" )                }
  let( :session ) { ::Qup::Session.new( "maildir://#{path}") }

  after do
    FileUtils.rm_rf( path )
  end

  it "has a uri" do
    session.uri.to_s.should == "maildir:#{path}"
  end

  it "can create a Queue" do
    q = session.queue( 'foo' )
    q.name.should == 'foo'
  end

  it "can create a Topic" do
    t = session.topic('t')
    t.name.should == 't'
  end
end
