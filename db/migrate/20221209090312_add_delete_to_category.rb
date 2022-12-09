class AddDeleteToCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :delete_at, :datetime, default: nil
  end
end