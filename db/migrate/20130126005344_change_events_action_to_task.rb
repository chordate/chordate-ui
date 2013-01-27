class ChangeEventsActionToTask < ActiveRecord::Migration
  def change
    rename_column :events, :action, :task
  end
end
