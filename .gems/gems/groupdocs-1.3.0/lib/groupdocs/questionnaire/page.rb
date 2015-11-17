module GroupDocs
  class Questionnaire::Page < Api::Entity

    # @attr [Integer] number
    attr_accessor :number
    # @attr [String] title
    attr_accessor :title
    # @attr [Array<GroupDocs::Questionnaire::Question>] questions
    attr_accessor :questions

    #
    # Converts each question to GroupDocs::Questionnaire::Question object.
    #
    # @param [Array<GroupDocs::Questionnaire::Question, Hash>] questions
    #
    def questions=(questions)
      if questions
        @questions = questions.map do |question|
          if question.is_a?(GroupDocs::Questionnaire::Question)
            question
          else
            Questionnaire::Question.new(question)
          end
        end
      end
    end

    #
    # Adds question to page.
    #
    # @param [GroupDocs::Questionnaire::Question] question
    # @raise [ArgumentError] if question is not GroupDocs::Questionnaire::Question object
    #
    def add_question(question)
      question.is_a?(GroupDocs::Questionnaire::Question) or raise ArgumentError,
        "Question should be GroupDocs::Questionnaire::Question object, received: #{question.inspect}"

      @questions ||= Array.new
      @questions << question
    end

  end # Questionnaire::Page
end # GroupDocs
