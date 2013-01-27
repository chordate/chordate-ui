class AddFlaggedAndStatusToEvents < ActiveRecord::Migration
  def change
    add_column :events, :flagged, :boolean, :default => false
    add_column :events, :status, :string, :default => "open"
  end
end
