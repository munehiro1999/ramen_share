class SorceryCore < ActiveRecord::Migration[7.1]
  def change
    change_table :users do |t|
      t.string :crypted_password
      t.string :salt

    end
    
    add_index :users, :email, unique: true unless index_exists?(:users, :email)
  end
end
