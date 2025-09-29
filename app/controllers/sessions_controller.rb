class SessionsController < ApplicationController
  def new
  end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_to users_path, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが間違っています"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to users_path, notice: "ログアウトしました"
  end
end
