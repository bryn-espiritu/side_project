class CreateRegions < ActiveRecord::Migration[7.0]
  def change
    create_table :regions do |t|
      t.string :region_name
      t.string :name
      t.string :code
      t.timestamps
    end
  end
end
