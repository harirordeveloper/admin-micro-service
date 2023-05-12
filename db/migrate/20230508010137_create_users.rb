class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :is_admin
      t.string :designation
      t.string :mobile
      t.string :address_line_1
      t.string :address_line_2
      t.integer :gender
      t.date :dob
      t.string :email
      t.string :type
      t.references :company, index: true

      t.timestamps
    end
  end
end
