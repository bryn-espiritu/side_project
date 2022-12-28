class ChangeColumnToBannerAndTicker < ActiveRecord::Migration[7.0]
  def change
    change_column :banners, :status, :integer, default: 0
    change_column :news_tickers, :status, :integer, default: 0
  end
end
