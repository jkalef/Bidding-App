class BidsController < ApplicationController
  before_action :authenticate_user!


  def create
    @auction = Auction.find params[:auction_id]
    @bid = current_user.bids.new(bid_params)
    @bid.auction = @auction
    
    respond_to do |format|
      if @auction.bids.any?
        @current_price = @auction.bids.highest_bid_so_far + 1
        if @bid.price <= @current_price
          format.html { redirect_to auction_path(@auction), alert: 
                    "Please make a bid greater than the current price"}
        else
          @bid.save
          format.html { redirect_to auction_path(@auction), notice: 
                                                      "Bid Created" }
          format.js { render }
        end
      else
        @current_price = @bid.price + 1
        @bid.save
        format.html { redirect_to auction_path(@auction) }
        format.js { render }
      end
    end
  end

  private

  def bid_params
    params.require(:bid).permit(:price)
  end 

end
