require 'spec_helper'

class Qup::AdapterTest < Qup::Adapter
  register :quptest
end

describe 'Adapter Registration' do
  it 'registers an adapter' do
    expect( Qup::Adapters['quptest'] ).to eq Qup::AdapterTest
  end
end

describe "Not Implementing the Adapter API" do
  let( :api ) { Qup::AdapterTest.new }

  %w[ close closed? ].each do |method|
    it "##{method} kaboom!" do
      expect {
        api.send( method )
        }.to raise_error( NotImplementedError, "please implement '#{method}'" )
    end
  end

  %w[ queue topic ].each do |method|
    it "##{method} kaboom!" do
      expect {
        api.send( method, 'foo' )
        }.to raise_error( NotImplementedError, "please implement '#{method}'" )
    end
  end

end
