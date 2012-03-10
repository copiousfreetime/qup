require 'spec_helper'
require 'qup/shared_adapter_examples'
require 'qup/adapter/kestrel_context'

describe 'Qup::Adapter::Kestrel', :kestrel => true do
  include_context "Qup::Adapter::Kestrel"
  it_behaves_like Qup::Adapter
end
