require 'spec_helper'

class Qup::QueueAPITest
  include Qup::QueueAPI
end

describe "Not Implementing the Queue API" do
  let( :api ) { Qup::QueueAPITest.new }

  %w[ name depth flush destroy consume ].each do |method|
    it "##{method} kaboom!" do
      lambda { api.send( method ) }.should raise_error( NotImplementedError, "please implement '#{method}'" )
    end
  end

  %w[ produce acknowledge ].each do |method|
    it "##{method} kaboom!" do
      lambda { api.send( method, nil ) }.should raise_error( NotImplementedError, "please implement '#{method}'" )
    end
  end
end
