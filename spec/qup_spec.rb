require "qup"

describe Qup do
  it "should have a version" do
    Qup::VERSION.should =~ ( %r[\A\d+\.\d+\.\d+\Z] )
  end
end
