class MakeLinkUrlNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :links, :url, true
  end
end
