class AddAasmStateColumnToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :aasm_state, :string
    add_index :auctions, :aasm_state
  end
end
