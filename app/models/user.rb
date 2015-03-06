# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  user_name  :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  validates :user_name, presence: true

  has_many(
    :authored_polls,
    class_name: :Poll,
    foreign_key: :user_id,
    primary_key: :id,
    dependent: :destroy
  )

  has_many(
    :responses,
    class_name: :Response,
    foreign_key: :user_id,
    primary_key: :id,
    dependent: :destroy
  )

  has_many(
    :follows,
    class_name: :FollowUser,
    foreign_key: :being_followed_id,
    primary_key: :id
  )

  has_many(
    :followers,
    through: :follows,
    source: :following
  )

  has_many(
    :people_following,
    class_name: :FollowUser,
    foreign_key: :is_following_id,
    primary_key: :id
  )

  has_many(
    :followees,
    through: :people_following,
    source: :followed
  )

has_many(
  :followed_polls,
  through: :followees,
  source: :authored_polls
)


  def completed_polls
    Poll
      .select('polls.*, COUNT(DISTINCT questions.id), COUNT(responses.user_id)')
      .joins('LEFT OUTER JOIN questions ON questions.poll_id = polls.id')
      .joins('LEFT OUTER JOIN answer_choices ON answer_choices.question_id = questions.id')
      .joins('LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id')
      .where('responses.user_id = ? OR responses.user_id IS NULL', self.id)
      .group('polls.id')
      .having('COUNT(DISTINCT questions.id) = COUNT(responses.user_id)')
  end
end
