class Like < ApplicationRecord
  belongs_to :user
  belongs_to :ramen_post

  validates :user_id, uniqueness: { scope: :ramen_post_id }

end
