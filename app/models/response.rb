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
    question.responses.where(":id IS NULL OR responses.id != :id", id: id)
  end

  private

  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(user_id: user_id)
      errors[:user_id] << "can't respond to same question twice"
    end
  end

  def respondent_did_not_author_poll
    if answer_choice.question.poll.user_id == self.user_id
      errors[:user_id] << "can't respond to own poll"
    end
  end
end
