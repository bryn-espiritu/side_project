class Admin::ItemsController < ApplicationController
  before_action :set_item, only: [:edit, :update, :destroy]

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_items_path, notice: 'Successfully Created!'
    else
      render :new
    end
  end


  def edit; end

  def update
    if @item.update(item_params)
      redirect_to admin_items_path, notice: 'Successfully Updated!'
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      redirect_to admin_items_path, notice: 'Successfully Deleted!'
    end
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :minimum_bets, :state, :batch_count, :online_at, :offline_at, :start_at, :status, :quantity)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end