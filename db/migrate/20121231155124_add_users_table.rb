class AddUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps
      t.string :name
      t.string :email
      t.string :token
      t.string :password
      t.integer :salt
    end
  end
end
