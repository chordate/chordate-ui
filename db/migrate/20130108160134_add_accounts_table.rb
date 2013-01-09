class AddAccountsTable < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.timestamps
      t.string :name
    end
  end
end
