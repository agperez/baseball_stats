class AddReferencesToStatsheets < ActiveRecord::Migration
  def change
    add_reference :statsheets, :player, index: true
    add_reference :statsheets, :team, index: true
    add_reference :statsheets, :season, index: true
    add_reference :statsheets, :season_stat, index: true
    add_reference :statsheets, :league, index: true
  end
end
