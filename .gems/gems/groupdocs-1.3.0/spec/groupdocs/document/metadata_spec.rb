require 'spec_helper'

describe GroupDocs::Document::MetaData do

  it_behaves_like GroupDocs::Api::Entity

  it { should have_accessor(:id)          }
  it { should have_accessor(:guid)        }
  it { should have_accessor(:page_count)  }
  it { should have_accessor(:views_count) }
  it { should have_accessor(:last_view)   }

  describe '#last_view=' do
    it 'converts passed hash to GroupDocs::Document::View object' do
      subject.last_view = { :document => { :id => 1, :name => 'test.pdf' } }
      subject.last_view.should be_a(GroupDocs::Document::View)
      subject.last_view.document.file.id.should == 1
      subject.last_view.document.file.name.should == 'test.pdf'
    end
  end
end
