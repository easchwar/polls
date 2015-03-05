User.destroy_all
Poll.destroy_all
Question.destroy_all
AnswerChoice.destroy_all
Response.destroy_all

ned = User.create!(user_name: "Ned")
cj = User.create!(user_name: "CJ")
vel = User.create!(user_name: "Velina")

poll1 = Poll.create!(title: "Favorite TA", user_id: ned.id)

q1 = Question.create!(text: "Who is it?", poll_id: poll1.id)

ac1 = AnswerChoice.create!(text: "CJ", question_id: q1.id)
ac2 = AnswerChoice.create!(text: "Jeff", question_id: q1.id)

Response.create!(answer_choice_id: ac1.id, user_id: cj.id)
Response.create!(answer_choice_id: ac2.id, user_id: vel.id)
