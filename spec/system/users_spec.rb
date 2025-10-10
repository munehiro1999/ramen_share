require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    # JSが必要な場合は :selenium_chrome_headless に変更可能
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }

  context "新規登録・ログイン" do
    it "新規ユーザー登録からログインまで" do
      visit signup_path

      fill_in "名前", with: "Taro"
      fill_in "メールアドレス", with: "taro@example.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード(確認)", with: "password"

      # アバター画像は fixtures に配置している場合
      avatar_path = Rails.root.join("spec/fixtures/avatar.png")
      attach_file "アバター画像", avatar_path if File.exist?(avatar_path)

      click_button "登録完了"

      expect(current_path).to eq(ramen_posts_path)
      expect(page).to have_content "ユーザーの登録が完了しました"
      expect(page).to have_content "新着投稿"
      expect(page).to have_content "人気投稿"
    end
  end

  context "プロフィール編集" do
    it "ログイン後にプロフィール編集ができる" do
      login(user)

      visit edit_user_path(user)
      fill_in "名前", with: "Updated Taro"
      click_button "編集完了"

      expect(page).to have_content "Updated Taro"
    end
  end

  context "自分の投稿一覧・いいね一覧" do
    it "自分の投稿一覧・いいね一覧ページが表示される" do
      login(user)

      visit my_posts_user_path(user)
      expect(page).to have_content "投稿一覧"

      visit liked_posts_user_path(user)
      expect(page).to have_content "いいねした投稿"
    end
  end

  context "ログアウト" do
    it "ログイン済みユーザーがログアウトできること", js: true do
      # JSが必要なので Selenium を使用
      driven_by(:selenium_chrome_headless)

      login(user)

      # ドロップダウンを開く
      find('#userMenu').click

      # JSアラートを自動承認してログアウト
      accept_confirm "ログアウトしますか？" do
        click_button "ログアウト"
      end

      # ログアウト後の確認
      expect(page).to have_content "ログアウトしました"
      expect(page).to have_button "ゲストログイン"
      expect(page).to have_link "ログイン"
      expect(page).to have_link "新規登録"
    end
  end

  private

  # Sorcery 用ログインヘルパー
  def login(user)
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"
  end
end
