require 'rails_helper'

RSpec.describe Bid, type: :model do
  def valid_bid_attributes(new_attributes)
    attributes = {price: 100}
    attributes.merge(new_attributes)
  end

  describe "validations" do
    it "is a number greater than 0" do
      b = Bid.new(valid_bid_attributes(price: "asfsa"))
      expect(b).to be_invalid
    end

    it "is present" do
      b = Bid.new(valid_bid_attributes(price: nil))
      expect(b).to be_invalid
    end

    it "is greater than the current bid on the product" do
      bid_1 = Bid.new(valid_bid_attributes(price: 100))
      bid_2 = Bid.new(valid_bid_attributes(price: 5))
      expect(bid_2).to be_invalid
    end

  end
end
