class CreateSeasonStats < ActiveRecord::Migration
  def change
    create_table :season_stats do |t|
      t.integer :games
      t.integer :ab
      t.integer :runs
      t.integer :hits
      t.integer :doubles
      t.integer :triples
      t.integer :hr
      t.integer :rbi
      t.integer :sb
      t.integer :cs

      t.timestamps
    end
  end
end
