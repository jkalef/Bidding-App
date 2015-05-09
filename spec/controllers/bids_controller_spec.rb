require 'rails_helper'

RSpec.describe BidsController, type: :controller do

  let(:user)  { create(:user) }
  let(:auction) { create(:auction) }
  let(:bid) { create(:bid, user: user, auction: auction)}
  let(:bid_1) { create(:bid, auction: auction)}

  describe "#create" do
    context "user not signed in" do
      it "redirects to the sign in page" do
        post :create, auction_id: auction.id,
                      bid: attributes_for(:bid)
        expect(response).to redirect_to new_session_path
      end
    end

    context "user signed in" do
      before { login(user) }

      context "with valid params" do
        def valid_request
          post :create, auction_id: auction.id,
                        bid: attributes_for(:bid)
        end

        it "creates a bid in the database" do
          expect { valid_request }.to change { Bid.count }.by(1)
        end

        it "associates the bid with the user" do
          valid_request
          expect(Bid.last.user).to eq(user)
        end

        it "associates the bid with the auction" do
          valid_request
          expect(Bid.last.auction).to eq(auction)
        end

        it "redirects to the auction show page" do
          valid_request
          expect(response).to redirect_to(auction_path(auction))
        end

        it "sets a flash message" do
          valid_request
          expect(flash[:notice]).to be
        end
      end

      context "with invalid params" do
        def invalid_request
          post :create, auction_id: auction.id,
                        bid: {price: "asfsa"}
        end

        it "doesn't increase the number of bids in the db" do
          expect { invalid_request }.to change {Bid.count}.by(0)
        end

        it "renders the auction show page" do
          invalid_request
          expect(response).to render_template("auctions/show")
        end

        it "sets a flash alert" do
          invalid_request
          expect(flash[:alert]).to be
        end
      end

    end
  end

end
