class CreateNewsTickers < ActiveRecord::Migration[7.0]
  def change
    create_table :news_tickers do |t|
      t.string :content
      t.string :status
      t.references :admin
      t.timestamps
    end
  end
end
