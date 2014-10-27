class AddSluggingToSeasonStats < ActiveRecord::Migration
  def change
    add_column :season_stats, :slg, :float
  end
end
