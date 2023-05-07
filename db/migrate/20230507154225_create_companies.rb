class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.text :address_line_1
      t.text :address_line_2
      t.string :phone

      t.timestamps
    end
  end
end
