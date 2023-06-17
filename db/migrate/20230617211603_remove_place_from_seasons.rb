class RemovePlaceFromSeasons < ActiveRecord::Migration[7.0]
  def change
    remove_column :seasons, :place, :string
  end
end
