class CreateWinners < ActiveRecord::Migration[7.0]
  def change
    create_table :winners do |t|
      t.references :bet
      t.references :item
      t.references :user
      t.references :admin, index: true
      t.references :address
      t.integer :item_batch_count
      t.string :state
      t.string :price
      t.string :paid_at
      t.string :picture
      t.string :comment
      t.timestamps
    end
  end
end
