require "spec_helper"

module Qup
  describe BackoffSleeper do
    before { allow(Kernel).to receive_messages(sleep: nil) }

    describe "#length" do
      it "it returns the multiplier averaged with the multiplier multiplied by rand" do
        expect(Kernel).to receive(:rand).with(no_args).and_return(0.5)

        sleeper = BackoffSleeper.new
        allow(sleeper).to receive_messages(multiplier: 1)

        expect( sleeper.length ).to eq( (1 + (1 * 0.5) ) / 2)
      end
    end

    describe "#tick" do
      it "starts count at 0" do
        expect( subject.count ).to eq 0
      end

      it "increments count by 1 everytime it's called" do
        subject.tick
        expect( subject.count ).to eq 1

        subject.tick
        expect( subject.count ).to eq 2
      end

      it "sleeps for #length if length is > 0" do
        expect( Kernel ).to receive(:sleep).with(0.123)

        allow( subject ).to receive_messages(length: 0.123)
        subject.tick
      end

      it "doesn't call sleep if the length is 0" do
        expect( Kernel ).to_not receive(:sleep).with(0)

        allow( subject).to receive_messages(length: 0)
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
        expect( subject.multiplier ).to eq 0
      end

      it "backs off exponentially" do
        multipliers = (0..2).map do
          subject.tick
          subject.multiplier
        end

        expect( multipliers ).to eq [0.01, 0.1, 1]
      end

      it "maxes out at the last value of MULTIPLIERS" do
        100.times { subject.tick }
        expect( subject.multiplier ).to eq BackoffSleeper::MULTIPLIERS.last
      end
    end
  end
end
