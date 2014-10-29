require 'rails_helper'

RSpec.describe SeasonStat, :type => :model do

  before(:each) { Statsheet.import_stats(Rails.root.join('app', 'assets', 'samplestats.csv')) }
  before(:each) { Statsheet.import_names(Rails.root.join('app', 'assets', 'samplenames.csv')) }

  it 'correctly identifies the Triple Crown winners' do
    expect(SeasonStat.triple_crown(2012)).to eq("a")
  end

end
