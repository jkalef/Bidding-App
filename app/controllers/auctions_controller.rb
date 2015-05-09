class AuctionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :show]

  def index
    @auctions = Auction.all
  end

  def new
    @auction = Auction.new
  end

  def create
    @auction = current_user.auctions.new(auction_params)
    if @auction.save
      redirect_to auction_path(@auction), notice: "Auction Created"
    else
      render :new
      flash[:alert] = "Sorry...something went wrong"
    end
  end


  def show
    @auction = Auction.find params[:id]
    @bid = current_user.bids.new

    if @auction.bids.any?
      @bids = @auction.bids.order_by_highest
      @current_price = @auction.bids.highest_bid_so_far + 1
    end
  end


  def edit
    @auction = current_user.auctions.find params[:id]
  end


  def update
    @auction = current_user.auctions.find params[:id]
    if @auction.update(auction_params)
      redirect_to auction_path(@auction), notice: "Auction Updated"
    else
      render :edit
      flash[:alert] = "Sorry...something went wrong"
    end
  end


  def destroy
    @auction = current_user.auctions.find params[:id]
    @auction.destroy
    redirect_to auctions_path, alert: "Auction deleted"
  end

  private

  def auction_params
    params.require(:auction).permit(:title, :details, :ends_on, :reserved_price)
  end

end
