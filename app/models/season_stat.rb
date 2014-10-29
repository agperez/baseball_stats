class SeasonStat < ActiveRecord::Base
  has_many :statsheets
  has_many :teams, through: :statsheets
  has_many :leagues, through: :statsheets

  belongs_to :player
  belongs_to :season

  def self.all_stats
    a = SeasonStat.most_improved(2009, 2010)
    b = SeasonStat.team_slugging("OAK", 2007)
    c = SeasonStat.triple_crown(2011)
    d = SeasonStat.triple_crown(2012)

    puts
    puts a
    puts
    puts b
    puts
    puts c
    puts
    puts d
    puts
  end

  def self.triple_crown(year)
    season = Season.find_by_year(year)

    top_rbi_AL = top_player(season, 399, 'AL', 'rbi DESC')
    top_rbi_NL = top_player(season, 399, 'NL', 'rbi DESC')
    top_hr_AL  = top_player(season, 399, 'AL', 'hr DESC')
    top_hr_NL  = top_player(season, 399, 'NL', 'hr DESC')
    top_avg_AL = top_player(season, 399, 'AL', 'avg DESC')
    top_avg_NL = top_player(season, 399, 'NL', 'avg DESC')

    al_winner = "AL: "+check_crown(top_rbi_AL, top_hr_AL, top_avg_AL, year)
    nl_winner = "NL: "+check_crown(top_rbi_NL, top_hr_NL, top_avg_NL, year)

    return [al_winner, nl_winner]
  end

  def self.most_improved(year1, year2)
    year1_id = Season.find_by_year(year1).id
    year2_id = Season.find_by_year(year2).id

    year1_players = find_season_ids(year1_id)
    year2_players = find_season_ids(year2_id)

    players = year1_players & year2_players

    stats = SeasonStat.where(:player_id => players)
                      .where("season_stats.season_id = ? OR season_stats.season_id = ?", year1_id, year2_id)
                      .order(:player_id)


    mip_result = find_mip(stats, year1_id)
    mip = Player.find(mip_result[0])
    mip_message = mip.first+" "+mip.last+" is the Most Improved Player from "+year1.to_s+" to "+year2.to_s+", with improvement: +"+mip_result[1].round(3).to_s

    return mip_message
  end

  def self.team_slugging(team, year)
    season = Season.find_by_year(year).id

    stats = SeasonStat.where("season_stats.season_id = ?", season).joins(:teams).where("name = ?", team)

    slugging_list = []
    slugging_list << "Slugging% for "+team+", "+year.to_s

    stats.each do |stat|
      player = stat.player
      name = player.first+" "+player.last
      slg = stat.slg == nil ? "N/A" : stat.slg.round(3).to_s

      slugging_list << name+": "+slg
    end

    slugging_list << "Total: "+stats.length.to_s

    return slugging_list
  end

  def self.check_crown(rbi, hr, avg, year)
    if rbi.player_id == hr.player_id and rbi.player_id == avg.player_id
      rbi.player.first+" "+rbi.player.last+" wins in "+year.to_s
    else
      "No Winner for "+year.to_s
    end
  end

  def self.find_season_ids(year_id)
    Player.joins(:season_stats)
          .where("season_stats.season_id = ?", year_id)
          .pluck(:id)
  end

  def self.find_mip(stats, year1_id)

    i = true
    first = ""
    second = ""
    year1_avg = 0.0
    year2_avg = 0.0
    top_avg = 0.0
    top_player = ""

    stats.each do |stat|
      if i
        first = stat
        i = false
      else
        second = stat
        if first.avg != nil && second.avg != nil && first.ab > 199 && second.ab > 199
          if first.season_id == year1_id
            year1_avg = first.avg
            year2_avg = second.avg
          else
            year1_avg = second.avg
            year2_avg = first.avg
          end
          improvement = year2_avg - year1_avg
          if improvement > top_avg
            top_avg = improvement
            top_player = first.player_id
          end
        end
        i = true
      end
    end
    return [top_player, top_avg]
  end

  def self.top_player(season, ab, league, stat_order)
    SeasonStat.where("season_stats.season_id = ? AND season_stats.ab > ?", season.id, ab)
                           .joins(:leagues).where("name = ?", league)
                           .order(stat_order).first
  end
end
