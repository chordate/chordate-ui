class AddApplicationsTable < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.timestamps
      t.belongs_to :account
      t.belongs_to :user
      t.string :name
      t.string :token
    end
  end
end
