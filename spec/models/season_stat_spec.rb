require 'rails_helper'

RSpec.describe SeasonStat, :type => :model do

  before(:each) do
    Statsheet.import_stats(Rails.root.join('app', 'assets', 'samplestats.csv'))
    Statsheet.import_names(Rails.root.join('app', 'assets', 'samplenames.csv'))
  end


  it 'correctly identifies Triple Crown winners' do
    expect(SeasonStat.triple_crown(2012)).to eq(["AL: Tony Abreu wins in 2012", "NL: A.J. Pierzynski wins in 2012"])
  end

  it 'correctly indentifies the Most Improved player' do
    expect(SeasonStat.most_improved(2011, 2012)).to eq("Bobby Abreu is the Most Improved Player from 2011 to 2012, with improvement: +0.108")
  end

  it 'correctly identifies the Slugging% for a team' do
    expect(SeasonStat.team_slugging('LAN', 2007)).to eq(["Slugging% for LAN, 2007", "Bobby Abreu: 0.445", "Tony Abreu: 0.404", "Total: 2"])
  end

  it 'correctly returns the top player for a Stat in a Season' do
    expect(SeasonStat.top_player(Season.find_by_year(2012), 399, 'NL', 'rbi DESC').player_id).to eq(4)
  end

  


end
