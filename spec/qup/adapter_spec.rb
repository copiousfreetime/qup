require 'spec_helper'

class Qup::AdapterTest < Qup::Adapter
  register :quptest
end

describe 'Adapter Registration' do
  it 'registers an adapter' do
    Qup::Adapters['quptest'].should eq Qup::AdapterTest
  end
end

describe "Not Implementing the Adapter API" do
  let( :api ) { Qup::AdapterTest.new }

  %w[ close closed? ].each do |method|
    it "##{method} kaboom!" do
      lambda { api.send( method ) }.should raise_error( NotImplementedError, "please implement '#{method}'" )
    end
  end
end
