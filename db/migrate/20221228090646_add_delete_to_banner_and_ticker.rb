class AddDeleteToBannerAndTicker < ActiveRecord::Migration[7.0]
  def change
    add_column :news_tickers, :deleted_at, :datetime
  end
end
