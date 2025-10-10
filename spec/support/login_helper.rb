module LoginHelper
  def login(user)
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"
  end
end

RSpec.configure do |config|
  config.include LoginHelper, type: :system
end
