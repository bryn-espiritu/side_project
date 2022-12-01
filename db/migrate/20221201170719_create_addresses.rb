class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.integer :genre, default: 0
      t.string :name
      t.string :street_address
      t.string :phone_number
      t.string :remark
      t.boolean :is_default
      t.references :user
      t.references :region
      t.references :province
      t.references :city_municipality
      t.timestamps
    end
  end
end
