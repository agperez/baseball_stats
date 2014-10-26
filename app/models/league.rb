class League < ActiveRecord::Base
  has_many :statsheets
  has_many :teams
  has_many :season_stats, through: :statsheets
end
