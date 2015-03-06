SELECT
  polls.user_id, polls.title
FROM
  answer_choices
LEFT OUTER JOIN
  questions ON questions.id = answer_choices.question_id
FULL OUTER JOIN
  polls ON polls.id = questions.poll_id
WHERE
  polls.user_id = 13
