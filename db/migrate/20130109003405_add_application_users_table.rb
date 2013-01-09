class AddApplicationUsersTable < ActiveRecord::Migration
  def change
    create_table :application_users do |t|
      t.timestamps
      t.belongs_to :application, :null => false
      t.belongs_to :user, :null => false
    end

    add_index :application_users, [:application_id, :user_id], :unique => true
  end
end
