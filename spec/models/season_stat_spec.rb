require 'rails_helper'

RSpec.describe SeasonStat, :type => :model do

  before(:all) { Statsheet.import_stats(Rails.root.join('app', 'assets', 'samplestats.csv')) }
  

end
