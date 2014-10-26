class AddReferenceToTeams < ActiveRecord::Migration
  def change
    add_reference :teams, :league
  end
end
