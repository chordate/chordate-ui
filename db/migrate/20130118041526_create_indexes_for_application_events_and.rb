class CreateIndexesForApplicationEventsAnd < ActiveRecord::Migration
  def up
    add_index :events, [:application_id]
    add_index :events, [:klass]
    add_index :events, [:env]
    add_index :events, [:generated_at]

    execute "CREATE INDEX index_users_on_substr_token ON users (substr(token, 0, 12))"
    execute "CREATE INDEX index_applications_on_substr_token ON applications (substr(token, 0, 10))"
  end

  def down
    execute "DROP INDEX index_applications_on_substr_token"
    execute "DROP INDEX index_users_on_substr_token"

    remove_index :events, [:generated_at]
    remove_index :events, [:env]
    remove_index :events, [:klass]
    remove_index :events, [:application_id]
  end
end
