require 'spec_helper'

%w(NoClientIdError NoPrivateKeyError UnsupportedMethodError BadResponseError).each do |error|
  describe GroupDocs.const_get(error) do
    it { should be_a(StandardError) }
  end
end
