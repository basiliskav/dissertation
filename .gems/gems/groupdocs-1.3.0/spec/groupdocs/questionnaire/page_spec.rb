require 'spec_helper'

describe GroupDocs::Questionnaire::Page do

  it_behaves_like GroupDocs::Api::Entity

  it { should have_accessor(:questions) }
  it { should have_accessor(:number)    }
  it { should have_accessor(:title)     }

  describe '#questions=' do
    it 'converts each question to GroupDocs::Questionnaire::Question object if hash is passed' do
      subject.questions = [{ :field => 'Field1', :text => 'Text1', :def_answer => 'A1' }]
      questions = subject.questions
      questions.should be_an(Array)
      questions.each do |question|
        question.should be_a(GroupDocs::Questionnaire::Question)
      end
    end

    it 'saves each question if it is GroupDocs::Questionnaire::Question object' do
      question1 = GroupDocs::Questionnaire::Question.new(:field => 'field1')
      question2 = GroupDocs::Questionnaire::Question.new(:field => 'field2')
      subject.questions = [question1, question2]
      subject.questions.should include(question1)
      subject.questions.should include(question2)
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.questions = nil
      end.should_not change(subject, :questions)
    end
  end

  describe '#add_question' do
    it 'raises error if question is not GroupDocs::Questionnaire::Page object' do
      lambda { subject.add_question('Page') }.should raise_error(ArgumentError)
    end

    it 'saves question' do
      question = GroupDocs::Questionnaire::Question.new
      subject.add_question(question)
      subject.questions.should == [question]
    end
  end
end
