require "spec_helper"

module Qup
  describe BackoffSleeper do
    before { Kernel.stub(:sleep) }

    describe "#length" do
      it "it returns the multiplier averaged with the multiplier multiplied by rand" do
        Kernel.stub(:rand).with().and_return(0.5)

        sleeper = BackoffSleeper.new
        sleeper.stub(:multiplier => 1)

        sleeper.length.should == (1 + (1 * 0.5)) / 2
      end
    end

    describe "#tick" do
      it "starts count at 0" do
        subject.count.should == 0
      end

      it "increments count by 1 everytime it's called" do
        subject.tick
        subject.count.should == 1

        subject.tick
        subject.count.should == 2
      end

      it "sleeps for #length if length is > 0" do
        Kernel.should_receive(:sleep).with(0.123)

        subject.stub(:length => 0.123)
        subject.tick
      end

      it "doesn't call sleep if the length is 0" do
        Kernel.should_not_receive(:sleep).with(0)

        subject.stub(:length => 0)
        subject.tick
      end
    end

    describe "#reset" do
      it "sets count back to 0" do
        subject.tick
        expect { subject.reset }.to change { subject.count }.to(0)
      end
    end

    describe "#multiplier" do
      it "starts at 0" do
        subject.multiplier.should == 0
      end

      it "backs off exponentially" do
        multipliers = (0..2).map do
          subject.tick
          subject.multiplier
        end

        multipliers.should == [0.01, 0.1, 1]
      end

      it "maxes out at the last value of MULTIPLIERS" do
        100.times { subject.tick }
        subject.multiplier.should == BackoffSleeper::MULTIPLIERS.last
      end
    end
  end
end