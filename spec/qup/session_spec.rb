require 'spec_helper'

describe Qup::Session do

  let( :path    ) { temp_dir( "qup-session" ) }
  let( :uri     ) { "maildir://#{path}"       }
  let( :session ) { ::Qup::Session.new( uri ) }

  after do
    FileUtils.rm_rf( path )
  end

  it "has a uri" do
    expect( session.uri.to_s ).to eq "maildir:#{path}"
  end

  it 'can be closed' do
    expect( session.closed? ).to be_falsey
    session.close
    expect( session.closed? ).to be_truthy
  end

  describe '#open' do
    it 'returns a new session' do
      s = Qup::Session.open( uri )
      expect( s.closed? ).to be_falsey
    end

    it 'yields a new session' do
      Qup::Session.open( uri ) do |s|
        expect( s.closed? ).to be_falsey
      end
    end

    it 'closes a session at the end of the block' do
      save_s = nil
      Qup::Session.open( uri ) do |s|
        expect( s.closed? ).to be_falsey
        save_s = s
      end
      expect( save_s.closed? ).to be_truthy
    end
  end

  describe '#queue' do
    it "can return a Queue" do
      q = session.queue( 'foo' )
      expect( q.name ).to eq 'foo'
    end

    it 'can yield a Queue' do
      session.queue( 'foo' ) do |q|
        expect( q.name ).to eq 'foo'
      end
    end

    it 'raises an error if accessing a closed Session' do
      session.close
      expect {
        session.queue( 'boom' )
        }.to raise_error( Qup::Session::ClosedError, /Session (.*) is closed/ )
    end
  end


  describe '#topic' do
    it "can return a Topic" do
      t = session.topic('t')
      expect( t.name ).to eq 't'
    end

    it 'can yiled a Topic' do
      session.topic('t') do |t|
        expect( t.name ).to eq 't'
      end
    end

    it 'raises an error if accessing a closed Session' do
      session.close
      expect {
        session.topic( 'boom' )
        }.to raise_error( Qup::Session::ClosedError, /Session (.*) is closed/ )
    end
  end

  describe '#options' do
    it "holds the options that are used to initialize the session" do
      s = Qup::Session.open( uri, { the: 'Option' } )
      expect( s.options[:the] ).to eq 'Option'
    end
  end
end
