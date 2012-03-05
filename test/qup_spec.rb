require "minitest/spec"
require "qup"

describe Qup do
  it "should have a version" do
    Qup::VERSION.must_match( %r[\A\d+\.\d+\.\d+\Z] )
  end
end
