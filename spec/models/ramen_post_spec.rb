# spec/system/ramen_posts_spec.rb
require 'rails_helper'

RSpec.describe "RamenPosts", type: :system do
  before do
    driven_by(:rack_test) # JS必須の場合 :selenium_chrome_headless に変更
  end

  let!(:user) { FactoryBot.create(:user, email: "test@example.com", password: "password") }

  it "ログインして投稿作成できる" do
    # ログイン画面
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    # ログイン成功を確認
    expect(page).to have_content("ログインしました")

    # 投稿作成ページ
    visit new_ramen_post_path
    fill_in "ラーメンの名前or(店名)", with: "テストラーメン"
    select "ramen", from: "ジャンル"

    # 星評価をクリック（JSありなら動作）
    find("#star-rating span[data-value='3.0']").click

    fill_in "概要", with: "美味しいラーメンです"

    # 住所
    fill_in "店舗住所(場所と名前を入れると正確に表示されます)", with: "東京都渋谷区1-2-3"

    click_button "投稿する"

    expect(page).to have_content("投稿を作成しました")
    expect(page).to have_content("テストラーメン")
  end

  it "投稿作成後に星評価を変更して投稿を編集できる" do
    # 事前に投稿を作成
    ramen_post = FactoryBot.create(:ramen_post, user: user, title: "テストラーメン", genre: "ramen", rating: 2.5)

    # ログイン
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    expect(page).to have_content("ログインしました")

    # 編集ページへ
    visit edit_ramen_post_path(ramen_post)
    fill_in "ラーメンの名前or(店名)", with: "編集ラーメン"

    # 星評価を変更
    find("#star-rating span[data-value='4.5']").click

    fill_in "概要", with: "編集後のコメント"
    click_button "編集完了する"

    expect(page).to have_content("投稿を更新しました")
    expect(page).to have_content("編集ラーメン")
  end
end
