class AddSlugToProduces < ActiveRecord::Migration[7.0]
  def change
    add_column :produces, :slug, :string
    add_index :produces, :slug, unique: true
  end
end
