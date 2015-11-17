shared_examples_for GroupDocs::Api::Helpers::AccessMode do
  it { should have_accessor(:access) }

  describe '#access' do
    it 'returns converted to human-readable format access mode' do
      subject.should_receive(:parse_access_mode).with('Restricted').and_return(:restricted)
      subject.access = 'Restricted'
      subject.access.should == :restricted
    end
  end
end
