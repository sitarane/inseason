class CreateVouches < ActiveRecord::Migration[7.0]
  def change
    create_table :vouches do |t|
      t.references :season, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :value, default: nil

      t.timestamps
    end
  end
end
