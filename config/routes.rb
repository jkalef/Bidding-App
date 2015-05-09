Rails.application.routes.draw do

  root "auctions#index"

  resources :users, only: [:new, :create, :show]
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  resources :auctions do
    resources :bids, only: [:new, :create]
    resources :close_auction, only: [:create]
  end

end
