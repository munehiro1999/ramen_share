class RenameScoreToRatingInRamenPosts < ActiveRecord::Migration[7.1]
  def change
    rename_column :ramen_posts, :score, :rating
  end
end
