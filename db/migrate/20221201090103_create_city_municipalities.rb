class CreateCityMunicipalities < ActiveRecord::Migration[7.0]
  def change
    create_table :city_municipalities do |t|
      t.string :name
      t.string :code
      t.references :province
      t.timestamps
    end
  end
end
