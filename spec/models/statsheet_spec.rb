require 'rails_helper'

RSpec.describe Statsheet, :type => :model do
  
  before(:all) { Statsheet.import_stats(Rails.root.join('app', 'assets', 'samplestats.csv')) }
  let(:player) { Player.find_by_importid("abreuto01").id }
  let(:season) { Season.find_by_year(2009).id }
  let(:stat)   { SeasonStat.where("player_id = ? AND season_id = ?", player, season) }

  it 'changes the number of Statsheets' do
    expect(Statsheet.count).to eq(11)
  end

  it 'changes the number of Players' do
    expect(Player.count).to eq(3)
  end

  it 'changes the number of Teams' do
    expect(Team.count).to eq(6)
  end

  it 'changes the number of Seasons' do
    expect(Season.count).to eq(6)
  end

  it 'changes the number of SeasonStats' do
    expect(SeasonStat.count).to eq(10)
  end

  it 'stores nil stat values as 0' do
    player = Player.find_by_importid("abreuju01").id
    season = Season.find_by_year(2011).id
    stat   = SeasonStat.where("player_id = ? AND season_id = ?", player, season)
    expect(stat.first.ab).to eq(0)
  end

  it 'combines season statistics' do
    expect(stat.first.ab + stat.first.runs).to eq(217)
  end

  it 'calculates season averages' do
    expect(stat.first.avg.round(3)).to eq(0.234)
  end

  it 'calculates season slugging' do
    expect(stat.first.slg.round(3)).to eq(0.313)
  end
end
