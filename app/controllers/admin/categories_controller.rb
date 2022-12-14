class Admin::CategoriesController < AdminController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: 'Saved'
    end
  end

  def edit;
  end

  def update

    if @category.update(category_params)
      redirect_to admin_items_path, notice: 'Successfully Updated!'
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      redirect_to admin_categories_path
    else
      render edit
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end

end
