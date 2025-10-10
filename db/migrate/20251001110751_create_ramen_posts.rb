class CreateRamenPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :ramen_posts do |t|
      t.string :title, null: :false
      t.integer :genre, null: :false
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
