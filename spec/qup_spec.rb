require "qup"

describe Qup do

  let( :path    ) { temp_dir( "qup" )   }
  let( :uri     ) { "maildir://#{path}" }

  it "should have a version" do
    Qup::VERSION.should =~ ( %r[\A\d+\.\d+\.\d+\Z] )
  end

  describe '#open' do
    it 'returns a new session' do
      s = Qup.open( uri )
      s.closed?.should be_false
    end

    it 'yields a new session' do
      Qup.open( uri ) do |s|
        s.closed?.should be_false
      end
    end

    it 'closes a session at the end of the block' do
      save_s = nil
      Qup.open( uri ) do |s|
        s.closed?.should be_false
        save_s = s
      end
      save_s.closed?.should be_true
    end
  end


  it "opens a new session" do
  end
end
