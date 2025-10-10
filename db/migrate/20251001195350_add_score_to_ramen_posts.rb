class AddScoreToRamenPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :ramen_posts, :score, :float
  end
end
