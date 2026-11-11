class Admin::ItemsController < AdminController
  before_action :set_item, only: [:edit, :update, :destroy, :start, :pause, :end, :cancel]

  def index
    @items = Item.includes(:categories).all
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

  def start
    if @item.start!
      flash[:notice] = "Successfully Started!"
    else
      flash[:alert] = @item.errors.full_messages.join(', ')
    end
    redirect_to admin_items_path
  end

  def pause
    if @item.pause!
      flash[:notice] = "Successfully Paused!"
    else
      flash[:alert] = @item.errors.full_messages.join(', ')
    end
    redirect_to admin_items_path
  end

  def cancel
    if @item.cancel!
      flash[:notice] = "Successfully Cancelled!"
    else
      flash[:alert] = @item.errors.full_messages.join(', ')
    end
    redirect_to admin_items_path
  end

  def end
    if @item.end!
      flash[:notice] = "Successfully Ended"
    else
      flash[:alert] = @item.errors.full_messages.join(', ')
    end
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :minimum_bets, :state, :batch_count, :online_at, :offline_at, :start_at, :status, :quantity, category_ids: [])
  end

  def set_item
    @item = Item.find(params[:id] || params[:item_id])
  end
end