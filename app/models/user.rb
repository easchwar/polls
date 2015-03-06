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
    primary_key: :id
  )

  has_many(
    :responses,
    class_name: :Response,
    foreign_key: :user_id,
    primary_key: :id
  )

  def completed_polls

    # heredoc = <<-SQL
    #   SELECT
    #     polls.*, COUNT(DISTINCT questions.id), COUNT(user_responses.id)
    #   FROM
    #     polls
    #   LEFT OUTER JOIN
    #     questions ON questions.poll_id = polls.id
    #   LEFT OUTER JOIN (
    #     SELECT
    #       responses.id AS id, answer_choices.question_id
    #     FROM
    #       answer_choices
    #     LEFT OUTER JOIN
    #       responses ON responses.answer_choice_id = answer_choices.id
    #     WHERE
    #       responses.user_id = ?
    #     ) AS user_responses ON user_responses.question_id = questions.id
    #   GROUP BY
    #     polls.id
    #   HAVING
    #   COUNT(DISTINCT questions.id) = COUNT(user_responses.id)
    # SQL

    # heredoc = <<-SQL
    #   SELECT
    #     polls.*, COUNT(DISTINCT questions.id), COUNT(responses.user_id)
    #   FROM
    #     polls
    #   LEFT OUTER JOIN
    #     questions ON questions.poll_id = polls.id
    #   LEFT OUTER JOIN
    #     answer_choices ON answer_choices.question_id = questions.id
    #   LEFT OUTER JOIN
    #     responses ON responses.answer_choice_id = answer_choices.id
    #   WHERE
    #     responses.user_id = ? OR responses.user_id IS NULL
    #   GROUP BY
    #     polls.id
    #   HAVING
    #     COUNT(DISTINCT questions.id) = COUNT(responses.user_id)
    # SQL
    #
    # Poll.find_by_sql([heredoc, id])

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
