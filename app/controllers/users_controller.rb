class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show, :liked_posts, :my_posts]
  before_action :check_guest_user, only: [:edit, :update, :destroy]
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
      redirect_to ramen_posts_path, notice: "ユーザーの登録が完了しました"
    else
      render "new", status: :unprocessable_entity
      #バリデーション失敗時にHTTPステータス(422)を返す
    end
  end

  def show
    @ramen_posts = @user.ramen_posts.order(created_at: :desc)
  end


  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: "ユーザーの情報を更新しました"
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
  end

  def my_posts
    @ramen_posts = @user.ramen_posts.order(created_at: :desc)

    respond_to do |format|
      format.html { render :show }
      format.turbo_stream { render partial: "users/my_posts", locals: { posts: @ramen_posts } }
    end
  end

  def liked_posts
    @ramen_posts = @user.liked_ramen_posts.order(created_at: :desc)

    respond_to do |format|
      format.html do
        @posts = @liked_ramen_posts
        render :show
      end

      format.turbo_stream { render partial: "users/user_liked_posts", locals: { posts: @ramen_posts } }
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :password, :password_confirmation)
  end

  def check_guest_user
    if @user.guest?
      redirect_to @user, notice: "ゲストユーザーはプロフィールを編集できません"
    end
  end
end
