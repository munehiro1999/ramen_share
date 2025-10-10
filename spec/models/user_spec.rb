require "rails_helper"

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it 'nameがなければ無効' do
      user = User.new(name: nil, email:"test@example.com", crypted_password: "password", salt: "salt")
      expect(user).not_to be_valid
    end

    it 'emailがなければ無効' do
      user = User.new(name: "Test", email: nil, crypted_password: "password": salt: "salt")
    end

    it 'emailが重複している場合は無効' do
      User.create!(name: "Test1", email: dup@example.com, crypted_password: "password", salt: "salt")
      user2 = User.new(name: "Test2", email: dup@example.com, crypted_password: "password", salt: "salt" )
    end
  end

  describe 'アソシエーション' do
    it 'ramen_postsを複数持っている' do
      assoc = User.reflect_on_assciation(:ramen_posts)
      expect(assoc.macro).to eq :has_many
    end

    it 'Likeを持つ' do
      assoc = User.reflect_on_assciation(:likes)
      exoect(assoc.macro).to eq :has_many
    end
  end
end
