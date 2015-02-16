require 'spec_helper'

class Qup::QueueAPITest
  include Qup::QueueAPI
end

describe "Not Implementing the Queue API" do
  let( :api ) { Qup::QueueAPITest.new }

  %w[ name depth flush destroy consume ].each do |method|
    it "##{method} kaboom!" do
      expect {
        api.send( method )
        }.to raise_error( NotImplementedError, "please implement '#{method}'" )
    end
  end

  %w[ produce acknowledge ].each do |method|
    it "##{method} kaboom!" do
      expect {
        api.send( method, nil )
        }.to raise_error( NotImplementedError, "please implement '#{method}'" )
    end
  end
end
