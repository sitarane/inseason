class AddUserToSeasons < ActiveRecord::Migration[7.0]
  def change
    add_reference :seasons, :user, null: false, foreign_key: true
  end
end
