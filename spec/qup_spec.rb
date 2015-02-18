require "qup"

describe Qup do

  let( :path    ) { temp_dir( "qup" )   }
  let( :uri     ) { "maildir://#{path}" }

  it "should have a version" do
    expect( Qup::VERSION ).to match( %r[\A\d+\.\d+\.\d+\Z] )
  end

  describe '#open' do
    it 'returns a new session' do
      s = Qup.open( uri )
      expect( s.closed? ).to be_falsey
    end

    it 'yields a new session' do
      Qup.open( uri ) do |s|
        expect( s.closed? ).to be_falsey
      end
    end

    it 'closes a session at the end of the block' do
      save_s = nil
      Qup.open( uri ) do |s|
        expect( s.closed? ).to be_falsey
        save_s = s
      end
      expect( save_s.closed? ).to be_truthy
    end
  end


  it "opens a new session" do
  end
end
