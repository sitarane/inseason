class AddSeasonsDeletedCountToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :seasons_deleted_count, :integer, default: 0, null: false
  end
end
