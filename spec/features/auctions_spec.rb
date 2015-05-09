require 'rails_helper'

RSpec.feature "Auctions", type: :feature do
  let(:user) { create(:user) }
  let(:auction) { create(:auction) }

  describe "Creating An Auction" do
    it "creates an auction and shows a flash message" do
      login_via_web(user)
      visit new_auction_path
      valid_attributes = attributes_for(:auction)

      fill_in "Title", with: valid_attributes[:title]
      fill_in "Details", with: valid_attributes[:details]
      fill_in "Reservered Price", with: valid_attributes[:reserved_price]
      fill_in "Ends On", with: valid_attributes[:ends_on]

      click_button "Create Auction"

      expect(Auction.count).to eq(1)
      expect(page).to have_content /Auction Created/i
    end
  end

end
