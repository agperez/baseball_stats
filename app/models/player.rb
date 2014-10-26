class Player < ActiveRecord::Base
  has_many :statsheets
  has_many :season_stats
  has_many :seasons,  through: :season_stats
  has_many :teams,    through: :statsheets

  validates :importid, presence: true
end
