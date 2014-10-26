class Season < ActiveRecord::Base
  has_many :season_stats
  has_many :statsheets
  has_many :players,  through: :statsheets
  has_many :teams,    through: :statsheets
end
