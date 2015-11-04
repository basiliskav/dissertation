shared_examples_for GroupDocs::Api::Helpers::Status do
  it { should have_accessor(:status) }

  describe '#status' do
    it 'returns converted to human-readable format status' do
      subject.should_receive(:parse_status).with('InProgress').and_return(:in_progress)
      subject.status = 'InProgress'
      subject.status.should == :in_progress
    end
  end
end
