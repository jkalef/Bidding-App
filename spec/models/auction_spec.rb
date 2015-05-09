require 'rails_helper'

RSpec.describe Auction, type: :model do
  def valid_attributes(new_attributes)
    attributes = {title: "Apple Computer",
                  details: "The best computer in town",
                  ends_on: "2015-07-08 09:39:19",
                  reserved_price: 1,
                  }
    attributes.merge(new_attributes)
  end

  describe "validations" do
    it "requires a title" do
      a = Auction.new(valid_attributes(title: nil))
      expect(a).to be_invalid
    end

    it "requires details" do
      a = Auction.new(valid_attributes(details: nil))
      expect(a).to be_invalid
    end

    it "requires a numerical reserved price" do
      a = Auction.new(valid_attributes(reserved_price: "asfas"))
      expect(a).to be_invalid
    end

    it "requires an end date" do
      a = Auction.new(valid_attributes(ends_on: nil))
      expect(a).to be_invalid
    end

  end
 
end
