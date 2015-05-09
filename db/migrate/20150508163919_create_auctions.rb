class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.string :title
      t.text :details
      t.datetime :ends_on
      t.integer :reserved_price
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
