class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      auto_login(@user) #sorceryのログイン関数
      redirect_to users_path, notice: "ユーザーの登録が完了しました"
    else
      render "new", status: :unprocessable_entity
      #バリデーション失敗時にHTTPステータス(422)を返す
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to :users_path, notice: "ユーザーの情報を更新しました"
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :password, :password_confirmation)
  end
end
