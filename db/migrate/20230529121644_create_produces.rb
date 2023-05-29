class CreateProduces < ActiveRecord::Migration[7.0]
  def change
    create_table :produces do |t|
      t.string :name
    end
  end
end
