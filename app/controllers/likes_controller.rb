class LikesController < ApplicationController


  def create
    @ramen_post = RamenPost.find(params[:ramen_post_id])
    @ramen_post.likes.create(user: current_user)

    respond_to do |format|
      format.html { redirect_back fallback_location: ramen_posts_path }
      format.turbo_stream
    end
  end

  def destroy
    @ramen_post = RamenPost.find(params[:ramen_post_id])
    like = @ramen_post.likes.find_by(user: current_user)
    like.destroy if like

    respond_to do |format|
      format.html { redirect_back fallback_location: ramen_posts_path }
      format.turbo_stream
    end
  end
end
