require 'rails_helper'

RSpec.describe AuctionsController, type: :controller do
  let(:user) { create(:user) }
  let(:auction) { create(:auction) }
  let(:auction_1) { create(:auction, user: user) }

  describe "#index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
    
    it "assigns an instance variable for all the available auctions" do
      auction
      auction_1
      get :index
      expect(assigns(:auctions)).to eq [auction, auction_1]
    end      
  end

  describe "#new" do
    context "user signed in" do
      before { login(user) }

      it "renders the new auction template" do
        get :new
        expect(response).to render_template(:new)
      end

      it "sets an instance variable to create a new auction" do
        get :new
        expect(assigns(:auction)).to be_a_new Auction
      end
    end

    context "user not signed in" do
      it "redirects to the sign in page" do
        get :new
        expect(response).to redirect_to new_session_path
      end
    end
  end

  describe "#create" do 
    context "user signed in" do
      before { login(user) }

      context "with valid params" do
        def valid_request
          attributes = attributes_for(:auction)
          post :create, auction: attributes
        end

        it "creates a new auction in the db" do
          expect { valid_request }.to change {Auction.count}.by(1)
        end

        it "redirects to the auction show page" do
          valid_request
          expect(response).to redirect_to(auction_path(Auction.last))
        end

        it "associates the auction with the user who made it"do
          valid_request
          expect(Auction.last.user).to eq(user)
        end

        it "sets a flash message" do
          valid_request
          expect(flash[:notice]).to be
        end
      end

      context "with invalid params" do
        def invalid_request
          post :create, auction: {title: nil}
        end

        it "doesn't make a new auction in the db" do
          expect { invalid_request }.to change {Auction.count}.by(0)
        end

        it "renders the new teomplate" do
          invalid_request
          expect(response).to render_template(:new)
        end

        it "sets a flash alert" do
          invalid_request
          expect(flash[:alert]).to be
        end

      end
    end

    context "user not signed in" do
      it "redirect to the sign in page" do
        post :create, auction: attributes_for(:auction)
        expect(response).to redirect_to new_session_path
      end
    end
  end

  describe "#edit" do
    context "user not signed in" do
      before { get :edit, id: auction.id }

      it "redirects to the sign in page" do
        expect(response).to redirect_to new_session_path
      end
    end

    context "user signed in" do
      context "auction own signed in?" do
        before { login(user) }
        before { get :edit, id: auction_1.id}

        it "renders the edit template" do
          expect(response).to render_template(:edit)
        end

        it "sets a auction instance variable with the proper id" do
          expect(assigns(:auction)).to eq(auction_1)
        end
      end

      context "non-auction owner logged in" do
        before { login(user) }

        it "raises an error if non-owner is logged in" do
          expect { get :edit, id: auction.id }.to raise_error
        end
      end
    end
  end

  describe "#show" do
    before { get :show, id: auction.id}

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    it "sets an instance variable equal to the id" do
      expect(assigns(:auction)).to eq(auction)
    end
  end

  describe "#update" do
    context "user not signed in" do
      it "redirects to the sign in page" do
        patch :update, id: auction.id, auction: {title: "valid title"}
        expect(response).to redirect_to new_session_path
      end
    end

    context "with owner user signed in" do
      before { login(user) }

      def valid_attributes(new_attributes = {})
        attributes_for(:auction).merge(new_attributes)
      end

      context "with valid attributes" do
        before do
          patch :update, id: auction_1.id, 
                         auction: valid_attributes(title: "update title")
        end

        it "updates the record in the db" do
          expect(auction_1.reload.title).to eq("update title")
        end

        it "redirects to the show page" do
          expect(response).to redirect_to(auction_path(auction_1))
        end

        it "sets a flash message" do
          expect(flash[:notice]).to be
        end
      end

      context "without valid attributes" do
        before do 
          patch :update, id: auction_1.id,
                         auction: valid_attributes(title: "")
        end

        it "doesn't update the record in the db" do
          expect(auction_1.reload.title).to_not eq("")
        end

        it "renders the edit template" do
          expect(response).to render_template(:edit)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to be
        end

      end

    end
  end

  describe "#destroy" do
    context "with user not signed in" do
      it "redirects to the sign in page" do
        delete :destroy, id: auction.id
        expect(response).to redirect_to new_session_path
      end
    end

    context "with user signed in" do
      before { login(user) }

      context "with non-own user signed in" do
        it "throws an error" do
          expect { delete :destroy, id: auction.id}.to raise_error
        end
      end

      # context "with owner user signed in" do
      #   it "reduces the number of auctions in the database by 1" do
      #     auction_1
      #     expect { delete :destroy, id: auction_1.id }.to change {Auction.count}.by(-1)
      #   end

      #   it "redirects to the auction index page" do
      #     delete :destroy, id: auction_1.id
      #     expect(response).to redirect_to auctions_path
      #   end

      #   it "sets a flash message" do
      #     delete :destroy, id: auction_1.id
      #     expect(flash[:notice]).to be
      #   end
      # end
    end


  end

end
