require 'spec_helper'
require 'qup/shared_adapter_examples'
require 'qup/adapter/maildir_context'

describe 'Qup::Adapter::Maildir', :maildir => true do
  include_context "Qup::Adapter::Maildir"
  it_behaves_like ::Qup::Adapter
end
