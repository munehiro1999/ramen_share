require 'rails_helper'

RSpec.describe "RamenPosts", type: :system, js: true do
  before do
    @user = FactoryBot.create(:user)
  end

  def login_user
    visit login_path
    fill_in "メールアドレス", with: @user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"
  end

  it "投稿の作成・編集・いいね・削除ができる" do
    login_user

    # -----------------------
    # 投稿作成
    # -----------------------
    visit new_ramen_post_path
    fill_in "ラーメンの名前or(店名)", with: "中華そば 田中"
    select "ラーメン", from: "ジャンル"
    page.execute_script("document.getElementById('rating-input').value = 3.5;")
    fill_in "概要", with: "あっさりした醤油ベース"
    fill_in "店舗住所(場所と名前を入れると正確に表示されます)", with: "東京都渋谷区○○1-2-3"
    click_button "投稿する"

    # 投稿作成後のカードを待つ（Turbo対応）
    expect(page).to have_selector(".main-container", text: "中華そば 田中", wait: 5)

    # -----------------------
    # 投稿編集
    # -----------------------
    card = find(".main-container", text: "中華そば 田中")
    within(card) do
      click_link "投稿詳細へ"
    end

    click_link "編集する"
    expect(page).to have_selector("input[name='ramen_post[title]']", visible: true)

    fill_in "ラーメンの名前or(店名)", with: "味噌一 改"
    select "ラーメン", from: "ジャンル"
    page.execute_script("document.getElementById('rating-input').value = 4.0;")
    fill_in "概要", with: "改訂版のコメントです"
    click_button "編集完了する"

    expect(page).to have_selector(".main-container", text: "味噌一 改", wait: 5)

    # -----------------------
    # いいね押す・取り消す
    # -----------------------
    card = find(".main-container", text: "味噌一 改")
    within(card) do
      turbo_frame = find("turbo-frame[id^='like_']")
      like_count = turbo_frame.find("span").text.to_i

      # いいね押す
      turbo_frame.find("button").click
      expect(turbo_frame).to have_selector("span", text: (like_count + 1).to_s, wait: 5)

      # いいね取り消す
      turbo_frame.find("button").click
      expect(turbo_frame).to have_selector("span", text: like_count.to_s, wait: 5)
    end

    # -----------------------
    # 投稿削除
    # -----------------------
    card = find(".main-container", text: "味噌一 改")
    within(card) do
      click_link "投稿詳細へ"
    end

    expect(page).to have_button("削除する", wait: 5)
    accept_confirm do
      click_button "削除する"
    end

    expect(page).not_to have_content("味噌一 改")
    expect(page).to have_selector(".main-container", wait: 5) # 他の投稿が残っている場合
  end
end
