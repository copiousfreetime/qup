require "minitest/spec"
require "qup"

describe Qup do
  it "should have a version" do
    qup::VERSION.must_match( %r[\A\d+\.\d+\.\d+\Z] )
  end

  it "should have some tests or I will kneecap you" do
    flunk
  end
end
