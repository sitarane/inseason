class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.belongs_to :produce, null: false, foreign_key: true
      t.integer :type, null: false
      t.string :url, null: false
    end
  end
end
