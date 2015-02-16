require 'spec_helper'

class Qup::TopicAPITest
  include Qup::TopicAPI
end

describe "Not Implementing the Topic API" do
  let( :api ) { Qup::TopicAPITest.new }

  %w[ name destroy publisher subscriber_count ].each do |method|
    it "##{method} kaboom!" do
      expect {
        api.send( method )
        }.to raise_error( NotImplementedError, /please implement '#{method}'/ )
    end
  end

  %w[ publish subscriber ].each do |method|
    it "##{method} kaboom!" do
      expect {
        api.send( method, nil )
        }.to raise_error( NotImplementedError, /please implement '#{method}'/ )
    end
  end
end
