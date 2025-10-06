class AddAddressAndCoordinatesToRamenPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :ramen_posts, :address, :string
    add_column :ramen_posts, :latitude, :float
    add_column :ramen_posts, :longitude, :float
  end
end
