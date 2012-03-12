# The shared context that all the Redis tests need to run.
# It is assumed that there is a Redis server running on localhost port 6379
shared_context "Qup::Adapter::Redis" do
  let( :uri     ) { URI.parse( "redis://localhost:6379/" ) }
  let( :adapter ) { ::Qup::Adapter::Redis.new( uri )       }
end
