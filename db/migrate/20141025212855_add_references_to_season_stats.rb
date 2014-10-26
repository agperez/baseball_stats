class AddReferencesToSeasonStats < ActiveRecord::Migration
  def change
    add_reference :season_stats, :player, index: true
    add_reference :season_stats, :season, index: true
  end
end
