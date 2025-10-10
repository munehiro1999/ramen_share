require 'rails_helper'

RSpec.describe "UsersController", type: :request do
  let(:user) do
    create(:user,
      name: "Taro",
      email: "taro@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  describe "GET /signup" do
    it "新規登録ページが正しく表示されていること" do
      get signup_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("ユーザー")
    end
  end

  describe "POST /users" do
    context "有効な情報の場合" do
      it "新しいユーザーが作成され、一覧ページにリダイレクトされていること" do
        expect {
          post users_path, params: {
            user: {
              name: "Hanako",
              email: "hanako@example.com",
              password: "password",
              password_confirmation: "password"
            }
          }
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(ramen_posts_path)
        follow_redirect!
        expect(response.body).to include("ユーザーの登録が完了しました")
      end
    end

    context "無効な情報の場合" do
      it "ユーザーは作成されず、新規登録ページが再表示されること(422)" do
        expect {
          post users_path, params: { user: { name: "", email: "", password: "", password_confirmation: "" } }
        }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("エラー").or include("登録")
      end
    end
  end

  describe "GET /users/:id" do
    it "指定ユーザーのプロフィールページが表示され、名前が含まれていること" do
      get user_path(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.name)
    end
  end

  describe "PATCH /users/:id" do
    it "ユーザー情報が正常に更新され、プロフィールページにリダイレクトされること" do
      patch user_path(user), params: { user: { name: "Updated Taro" } }
      user.reload
      expect(user.name).to eq("Updated Taro")
      expect(response).to redirect_to(user_path(user))
    end

    it "無効な情報の場合は編集ページが再表示されること(422)" do
      patch user_path(user), params: { user: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /users/:id/my_posts" do
    it "自分の投稿一覧ページが正常に表示されていること" do
      get my_posts_user_path(user)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /users/:id/liked_posts" do
    it "いいねした投稿一覧ページが正常に表示されていること" do
      get liked_posts_user_path(user)
      expect(response).to have_http_status(:ok)
    end
  end
end
