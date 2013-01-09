class AddAccountsToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_id, :integer
  end
end
