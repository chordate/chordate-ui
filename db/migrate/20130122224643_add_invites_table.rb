class AddInvitesTable < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.timestamps
      t.belongs_to :user
      t.belongs_to :application
      t.string :email
      t.string :token
      t.datetime :shown
    end
  end
end
