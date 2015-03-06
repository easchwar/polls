# == Schema Information
#
# Table name: follow_users
#
#  id                :integer          not null, primary key
#  is_following_id   :integer          not null
#  being_followed_id :integer          not null
#  created_at        :datetime
#  updated_at        :datetime
#

class FollowUser < ActiveRecord::Base
  belongs_to(
    :followed,
    class_name: :User,
    foreign_key: :being_followed_id,
    primary_key: :id
  )

  belongs_to(
    :following,
    class_name: :User,
    foreign_key: :is_following_id,
    primary_key: :id
  )
end
