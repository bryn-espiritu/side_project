class RemoveCoinAtUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :coins
  end
end
