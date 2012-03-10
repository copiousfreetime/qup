# The common context needed for all the Maildir Adapter tests.
#
# All the maildir tests will be run in the 'path' below
shared_context 'Qup::Adapter::Maildir' do
  let( :path    ) { temp_dir( "qup-maildir" )          }
  let( :uri     ) { URI.parse( "maildir://#{path}" )   }

  # Needed to support the Shared Examples
  let( :adapter ) { ::Qup::Adapter::Maildir.new( uri ) }
end
