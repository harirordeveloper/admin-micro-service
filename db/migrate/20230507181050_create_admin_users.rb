class CreateAdminUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :admin_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :mobile
      t.string :address_line_1
      t.string :address_line_2
      t.integer :gender
      t.datetime :dob
      t.string :email

      t.timestamps
    end
  end
end
