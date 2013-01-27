class AddHstoreDataToEvents < ActiveRecord::Migration
  def change
    add_column :events, :user, :hstore
    add_column :events, :server, :hstore
    add_column :events, :extra, :hstore
    add_column :events, :backtrace, :string_array
  end
end
