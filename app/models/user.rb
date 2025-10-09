class User < ApplicationRecord
  authenticates_with_sorcery!
  has_one_attached :avatar
  has_many :ramen_posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_ramen_posts, through: :likes, source: :ramen_post

  validates :name, presence: true #空文字を入れない
  validates :email, presence: true, uniqueness: true

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  def guest?
    email == "guest@example.com"
  end
end
