class ChangeSeasonIdInVouchesToNullable < ActiveRecord::Migration[8.1]
  def change
    change_column_null :vouches, :season_id, true
  end
end
