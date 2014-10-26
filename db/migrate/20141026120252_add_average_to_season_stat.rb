class AddAverageToSeasonStat < ActiveRecord::Migration
  def change
    add_column :season_stats, :avg, :float 
  end
end
