# == Schema Information
#
# Table name: answer_choices
#
#  id          :integer          not null, primary key
#  text        :string           not null
#  question_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class AnswerChoice < ActiveRecord::Base
  validates :text, presence: true
  validates :question_id, presence: true
  
  belongs_to(
    :question,
    class_name: :Question,
    foreign_key: :question_id,
    primary_key: :id
  )

  has_many(
    :responses,
    class_name: :Response,
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

end
