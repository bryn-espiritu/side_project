class AddColumnToItem < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :batch_count, :integer, default: 0
  end
end
