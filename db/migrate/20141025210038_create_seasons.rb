class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.date :year

      t.timestamps
    end
    add_index :seasons, :year, unique: true
  end
end
