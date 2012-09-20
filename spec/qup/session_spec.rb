require 'spec_helper'

describe Qup::Session do

  let( :path    ) { temp_dir( "qup-session" ) }
  let( :uri     ) { "maildir://#{path}"       }
  let( :session ) { ::Qup::Session.new( uri ) }

  after do
    FileUtils.rm_rf( path )
  end

  it "has a uri" do
    session.uri.to_s.should == "maildir:#{path}"
  end

  it 'can be closed' do
    session.closed?.should be_false
    session.close
    session.closed?.should be_true
  end

  describe '#open' do
    it 'returns a new session' do
      s = Qup::Session.open( uri )
      s.closed?.should be_false
    end

    it 'yields a new session' do
      Qup::Session.open( uri ) do |s|
        s.closed?.should be_false
      end
    end

    it 'closes a session at the end of the block' do
      save_s = nil
      Qup::Session.open( uri ) do |s|
        s.closed?.should be_false
        save_s = s
      end
      save_s.closed?.should be_true
    end
  end

  describe '#queue' do
    it "can return a Queue" do
      q = session.queue( 'foo' )
      q.name.should == 'foo'
    end

    it 'can yield a Queue' do
      session.queue( 'foo' ) do |q|
        q.name.should == 'foo'
      end
    end

    it 'raises an error if accessing a closed Session' do
      session.close
      lambda { session.queue( 'boom' ) }.should raise_error( Qup::Session::ClosedError, /Session (.*) is closed/ )
    end
  end


  describe '#topic' do
    it "can return a Topic" do
      t = session.topic('t')
      t.name.should == 't'
    end

    it 'can yiled a Topic' do
      session.topic('t') do |t|
        t.name.should == 't'
      end
    end

    it 'raises an error if accessing a closed Session' do
      session.close
      lambda { session.topic( 'boom' ) }.should raise_error( Qup::Session::ClosedError, /Session (.*) is closed/ )
    end
  end

  describe '#options' do
    it "holds hte options that are used to initialize the session" do
      s = Qup::Session.open( uri, { :the => 'Option' } )
      s.options[:the].should == 'Option'
    end
  end
end
