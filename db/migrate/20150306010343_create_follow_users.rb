class CreateFollowUsers < ActiveRecord::Migration
  def change
    create_table :follow_users do |t|
      t.integer :is_following_id, null: false
      t.integer :being_followed_id, null: false

      t.timestamps
    end

    add_index :follow_users, :is_following_id
    add_index :follow_users, :being_followed_id
  end
end
