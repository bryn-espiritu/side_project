class Admin::NewsTickersController < AdminController
  before_action :set_news_ticker, only: [:update, :destroy, :edit]

  def index
    @news_tickers = NewsTicker.all
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)
    if @news_ticker.save
      redirect_to admin_news_tickers_path, notice: 'Successfully Created!'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @news_ticker.update(news_ticker_params)
      redirect_to admin_news_tickers_path, notice: 'Successfully Updated!'
    else
      render :edit
    end
  end

  def destroy
    @news_ticker.destroy
    redirect_to admin_news_tickers_path, notice: 'Successfully Deleted!'
  end

  private

  def news_ticker_params
    params.require(:news_ticker).permit(:content, :status, :admin_id)
  end

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id] || params[:news_ticker_id])
  end
end
