class AddLocationToUser < ActiveRecord::Migration
  def change
    add_column :users, :location, :string, null: false, default: ""
    add_column :users, :last_seen_at, 'TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP'

  end
end
