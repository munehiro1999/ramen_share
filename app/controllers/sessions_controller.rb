class SessionsController < ApplicationController
  def new
  end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_to ramen_posts_path, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが間違っています"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to ramen_posts_path, notice: "ログアウトしました"
  end

  def guest_login
    guest = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.name = 'ゲスト'
      password = SecureRandom.urlsafe_base64
      user.password = password
      user.password_confirmation = password
    end

    session[:user_id] = guest.id
    redirect_to ramen_posts_path, notice: "ゲストログインしました"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to root_path, notice: "ゲストログインに失敗しました: #{e.message}"
  end
end
