class User < ApplicationRecord
  validates :name, presence: true #空文字を入れない
  validates :email, presence: true, uniqueness: true
  #空文字＋同一の値を入れない
  
end
