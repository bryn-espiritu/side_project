class UpdateColumnToItem < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :batch_count
  end
end
