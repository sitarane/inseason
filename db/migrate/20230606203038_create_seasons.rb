class CreateSeasons < ActiveRecord::Migration[7.0]
  def change
    create_table :seasons do |t|
      t.float :latitude
      t.float :longitude
      t.belongs_to :produce, null: false, foreign_key: true
      t.integer :start_time
      t.integer :end_time

      t.timestamps
    end
  end
end
