class AddPlaceToSeasons < ActiveRecord::Migration[7.0]
  def change
    add_column :seasons, :place, :string
  end
end
