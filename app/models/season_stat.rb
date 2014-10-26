class SeasonStat < ActiveRecord::Base
  has_many :statsheets
  has_many :teams, through: :statsheets
  has_many :leagues, through: :statsheets

  belongs_to :player
  belongs_to :season

  
end
