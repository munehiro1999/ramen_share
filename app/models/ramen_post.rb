class RamenPost < ApplicationRecord
  belongs_to :user
  has_one_attached :image, dependent: :destroy
  enum genre: { "ラーメン": 0, "つけ麺": 1, "油そば": 2 }

  validates :title, presence: true
  validates :genre, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to:5 }, allow_nil: true
end
