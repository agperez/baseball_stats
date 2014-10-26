class Team < ActiveRecord::Base
  has_many :statsheets
  has_many :players, through: :statsheets
  has_many :seasons, through: :statsheets

  belongs_to :league
end
