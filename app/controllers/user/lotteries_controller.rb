class User::LotteriesController < ApplicationController
  def index
    @items = Item.starting.active
    @items = @items.includes(:categories).where(categories: {name: params[:categories]}) if params[:categories]
    @categories = Category.all
  end
end
