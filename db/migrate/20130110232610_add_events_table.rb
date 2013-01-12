class AddEventsTable < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.timestamps
      t.datetime :generated_at
      t.belongs_to :account
      t.belongs_to :application
      t.string :env
      t.string :klass
      t.string :message
      t.string :source
      t.string :action
      t.string :model_type
      t.string :model_id
    end
  end
end
