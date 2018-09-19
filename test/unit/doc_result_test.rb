require 'test_helper'

class DocResultTest < ActiveSupport::TestCase
  test 'should return fromSearch' do
    question = nodes(:question)

    result = DocResult.new(
      docId: question.nid,
      docType: 'QUESTIONS',
      docUrl: question.path(:question),
      docTitle: question.title,
      score: question.answers.length
    )

    assert_equal question.nid,    result.docId
    assert_equal 'QUESTIONS',     result.docType
  end
end
