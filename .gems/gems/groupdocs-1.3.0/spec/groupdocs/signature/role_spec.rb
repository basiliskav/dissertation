require 'spec_helper'

describe GroupDocs::Signature::Role do

  it_behaves_like GroupDocs::Api::Entity

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('signature_roles_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!({}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'allows passing options' do
      lambda { described_class.get!(:id => "dsaoij3928ukr03") }.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Signature::Role objects' do
      roles = described_class.get!
      roles.should be_an(Array)
      roles.each do |role|
        role.should be_a(GroupDocs::Signature::Role)
      end
    end
  end

  it { should have_accessor(:id)          }
  it { should have_accessor(:name)        }
  it { should have_accessor(:canEdit)     }
  it { should have_accessor(:canSign)     }
  it { should have_accessor(:canAnnotate) }
  it { should have_accessor(:canDelegate) }

  it { should alias_accessor(:can_edit, :canEdit)         }
  it { should alias_accessor(:can_sign, :canSign)         }
  it { should alias_accessor(:can_annotate, :canAnnotate) }
  it { should alias_accessor(:can_delegate, :canDelegate) }

  describe '#can_edit?' do
    it 'returns true if role can edit' do
      subject.can_edit = 1
      subject.can_edit?.should be_true
    end

    it 'returns false if role cannot edit' do
      subject.can_edit = 0
      subject.can_edit?.should be_false
    end
  end

  describe '#can_sign?' do
    it 'returns true if role can sign' do
      subject.can_sign = 1
      subject.can_sign?.should be_true
    end

    it 'returns false if role cannot sign' do
      subject.can_sign = 0
      subject.can_sign?.should be_false
    end
  end

  describe '#can_annotate?' do
    it 'returns true if role can annotate' do
      subject.can_annotate = 1
      subject.can_annotate?.should be_true
    end

    it 'returns false if role cannot annotate' do
      subject.can_annotate = 0
      subject.can_annotate?.should be_false
    end
  end

  describe '#can_delegate?' do
    it 'returns true if role can delegate' do
      subject.can_delegate = 1
      subject.can_delegate?.should be_true
    end

    it 'returns false if role cannot delegate' do
      subject.can_delegate = 0
      subject.can_delegate?.should be_false
    end
  end
end
