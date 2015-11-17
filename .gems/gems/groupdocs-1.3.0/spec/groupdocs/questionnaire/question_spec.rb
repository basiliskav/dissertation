require 'spec_helper'

describe GroupDocs::Questionnaire::Question do

  it_behaves_like GroupDocs::Api::Entity

  it { should have_accessor(:field)      }
  it { should have_accessor(:text)       }
  it { should have_accessor(:def_answer) }
  it { should have_accessor(:required)   }
  it { should have_accessor(:type)       }
  it { should have_accessor(:answers)    }

  it { should alias_accessor(:default_answer, :def_answer) }

  describe '#answers=' do
    it 'converts each answer to GroupDocs::Questionnaire::Question::Answer object' do
      subject.answers = [{ :text => 'Text1', :value => 'Value1' }, { :text => 'Text2', :value => 'Value2' }]
      answers = subject.answers
      answers.should be_an(Array)
      answers.each do |answer|
        answer.should be_a(GroupDocs::Questionnaire::Question::Answer)
      end
    end

    it 'saves each answer if it is GroupDocs::Questionnaire::Question::Answer object' do
      answer1 = GroupDocs::Questionnaire::Question::Answer.new(:text => 'text1')
      answer2 = GroupDocs::Questionnaire::Question::Answer.new(:text => 'text2')
      subject.answers = [answer1, answer2]
      subject.answers.should include(answer1)
      subject.answers.should include(answer2)
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.answers = nil
      end.should_not change(subject, :answers)
    end
  end

  describe '#add_answer' do
    it 'raises error if answer is not GroupDocs::Questionnaire::Question::Answer object' do
      lambda { subject.add_answer('Answer') }.should raise_error(ArgumentError)
    end

    it 'saves answer' do
      answer = GroupDocs::Questionnaire::Question::Answer.new(:text => 'Text', :value => 'Value')
      subject.add_answer(answer)
      subject.answers.should == [answer]
    end
  end

  describe '#type=' do
    it 'saves type in machine readable format if symbol is passed' do
      subject.type = :generic_text
      subject.instance_variable_get(:@type).should == 'GenericText'
    end

    it 'does nothing if parameter is not symbol' do
      subject.type = 'GenericText'
      subject.instance_variable_get(:@type).should == 'GenericText'
    end

    it 'raises error if type is unknown' do
      lambda { subject.type = :unknown }.should raise_error(ArgumentError)
    end
  end

  describe '#type' do
    it 'returns type in human-readable format' do
      subject.type = 'GenericText'
      subject.type.should == :generic_text
    end
  end
end
