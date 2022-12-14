class CreateBets < ActiveRecord::Migration[7.0]
  def change
    create_table :bets do |t|
      t.references :item
      t.references :user
      t.integer :batch_count, default: 0
      t.integer :coin, default: 1
      t.string :serial_number
      t.string :state
      t.timestamps
    end
  end
end
