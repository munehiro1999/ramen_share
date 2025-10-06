class RamenPost < ApplicationRecord
  belongs_to :user
  has_many_attached :images, dependent: :destroy
  enum genre: { ramen: 0, tukemen: 1, aburasoba: 2 }

  validates :title, presence: true
  validates :genre, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to:5 }, allow_nil: true

  #住所から緯度と経度を自動取得
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
