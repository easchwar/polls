# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  answer_choice_id :integer          not null
#  created_at       :datetime
#  updated_at       :datetime
#

class Response < ActiveRecord::Base
  validates :user_id, presence: true
  validates :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :respondent_did_not_author_poll

  belongs_to(
    :respondent,
    class_name: :User,
    foreign_key: :user_id,
    primary_key: :id
  )

  belongs_to(
    :answer_choice,
    class_name: :AnswerChoice,
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  has_one(
    :question,
    through: :answer_choice,
    source: :question
  )

  def sibling_responses
    Response
      .select('responses.*')
      .joins('JOIN answer_choices AS ac1 ON responses.answer_choice_id = ac1.id')
      .joins('JOIN questions AS q ON q.id = ac1.question_id')
      .joins('JOIN answer_choices AS ac2 ON q.id = ac2.question_id')
      .where('ac2.id = ? and (responses.id != ? OR  ? is NULL)', answer_choice_id, id, id)
  end

  private

  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(user_id: user_id)
      errors[:user_id] << "can't respond to same question twice"
    end
  end

  def respondent_did_not_author_poll
    poll = Poll
      .select('polls.*')
      .joins(:questions)
      .joins('JOIN answer_choices ON answer_choices.question_id = questions.id')
      .where('answer_choices.id = ?', self.answer_choice_id)

    if poll.first.user_id == self.user_id
      errors[:user_id] << "can't respond to own poll"
    end
  end
end
