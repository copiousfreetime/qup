require 'spec_helper'

# The Queue share context requires that the context is include in define:
#
#   let( :adapter )
#
shared_context "Qup::Queue" do

  let( :queue ) { adapter.queue( 'foo' ) }

  after do
    queue.destroy
  end

end

shared_examples Qup::QueueAPI do

  it "has a name" do
    expect( queue.name ).to eq 'foo'
  end

  describe "#produce" do
    it "produces an item on the queue" do
      expect( queue.depth ).to eq 0
      queue.produce( "a new message" )
      expect( queue.depth ).to eq 1
    end

    it "does not create multiple messages for newlines" do
      queue.produce( "one\nsingle\nmessage" )
      expect( queue.depth ).to eq 1
    end
  end

  it "#flush" do
    10.times { |x| queue.produce( "message #{x}" ) }
    expect(queue.depth).to eq 10
    queue.flush
    expect(queue.depth).to eq 0
  end

  describe '#consume' do
    before do
      queue.produce( "consumeable message" )
      expect(queue.depth).to eq 1
    end

    it 'normally' do
      msg = queue.consume
      expect( msg.data ).to eq "consumeable message"
    end

    it 'with block it auto acknowledges' do
      queue.consume do |msg|
        expect( msg.data ).to eq 'consumeable message'
      end
    end

    it 'returns nil if the queue is empty (it is non-blocking)' do
      queue.consume
      expect( queue.consume).to be_nil
    end
  end

  describe "#acknowledge" do
    it "acks a message" do
      queue.produce( "acknowledgeable message" )
      expect( queue.depth ).to eq 1

      msg = queue.consume
      expect( msg.data ).to eq "acknowledgeable message"

      queue.acknowledge( msg )
      expect( queue.depth ).to eq 0
    end

    it "raises an error if you attempt to to acknowledge an unconsumed message" do
      msg = queue.produce( 'unconsumed' )
      expect { queue.acknowledge( msg ) }.to raise_error(Qup::Error)
    end
  end
end
