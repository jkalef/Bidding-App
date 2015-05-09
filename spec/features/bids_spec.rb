require 'rails_helper'

RSpec.feature "Bids", type: :feature do
  let(:user) { create(:user) }
  let(:auction) { create(:auction) }
  let(:bid) { create(:bid) }
  
  describe "Creating A Bid" do
    it "creates a bid and associates the bid with the auction" do
      login_via_web(user)
      visit auction_path
      valid_attributes = attributes_for(:bid)

      fill_in "price", with: valid_attributes[:price]

      click_button "Bid"

      expect(Bid.count).to eq(1)
      expect(Bid.last.auction).to eq(:auction)
    end
  end

end
