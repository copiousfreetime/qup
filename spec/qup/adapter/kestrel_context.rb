# The Shared Context that all the Kestrel tests need to run.
# It is assumed that there is a Kestrel server running on localhost port 22133
shared_context "Qup::Adapter::Kestrel" do
  let( :uri     ) { URI.parse( "kestrel://localhost:22133/" )   }
  let( :adapter ) { ::Qup::Adapter::Kestrel.new( uri )          }
end


