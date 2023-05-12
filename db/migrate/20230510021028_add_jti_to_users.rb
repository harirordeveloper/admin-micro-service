class AddJtiToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :jti, :string, null: false
    add_column :users, :password_digest, :string
    add_index :users, :jti, unique: true
  end
end
