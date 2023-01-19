class HomeController < ApplicationController
  def index
    @banners = Banner.active
    @news_tickers = NewsTicker.active
    @winners = Winner.includes(:item, :user).published
  end
end
