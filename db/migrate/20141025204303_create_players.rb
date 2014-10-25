class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :first
      t.string :last
      t.string :importid

      t.timestamps
    end
    add_index :players, :importid, unique: true
  end
end
