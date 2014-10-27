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

    top_rbi_AL = SeasonStat.where("season_stats.season_id = ? AND season_stats.ab > ?", season.id, 399)
                           .joins(:leagues).where("name = ?", 'AL')
                           .order("rbi DESC").first

    top_rbi_NL = SeasonStat.where("season_stats.season_id = ? AND season_stats.ab > ?", season.id, 399)
                           .joins(:leagues).where("name = ?", 'NL')
                           .order("rbi DESC").first

    top_hr_AL  = SeasonStat.where("season_stats.season_id = ? AND season_stats.ab > ?", season.id, 399)
                           .joins(:leagues).where("name = ?", 'AL')
                           .order("hr DESC").first

    top_hr_NL  = SeasonStat.where("season_stats.season_id = ? AND season_stats.ab > ?", season.id, 399)
                           .joins(:leagues).where("name = ?", 'NL')
                           .order("hr DESC").first

    top_avg_AL = SeasonStat.where("season_stats.season_id = ? AND season_stats.ab > ?", season.id, 399)
                           .joins(:leagues).where("name = ?", 'AL')
                           .order("avg DESC").first

    top_avg_NL = SeasonStat.where("season_stats.season_id = ? AND season_stats.ab > ?", season.id, 399)
                           .joins(:leagues).where("name = ?", 'NL')
                           .order("avg DESC").first

    if top_rbi_AL.player_id == top_hr_AL.player_id and top_rbi_AL.player_id == top_avg_AL.player_id
      al_winner = year.to_s+" AL Winner: "+top_rbi_AL.player.first+" "+top_rbi_AL.player.last
    else
      al_winner = "No AL Winner for "+year.to_s
    end

    if top_rbi_NL.player_id == top_hr_NL.player_id and top_rbi_NL.player.id == top_avg_NL.player_id
      nl_winner = year.to_s+" NL Winner: "+top_rbi_NL.player.first+" "+top_rbi_NL.player.last
    else
      nl_winner = "No NL Winner for "+year.to_s
    end

    return [al_winner, nl_winner]
  end

  def self.most_improved(year1, year2)
    year1_id = Season.find_by_year(year1).id
    year2_id = Season.find_by_year(year2).id

    year1_players = Player.joins(:season_stats)
                          .where("season_stats.season_id = ?", year1_id)
                          .pluck(:id)

    year2_players = Player.joins(:season_stats)
                          .where("season_stats.season_id = ?", year2_id)
                          .pluck(:id)

    players = year1_players & year2_players

    stats = SeasonStat.where(:player_id => players)
                      .where("season_stats.season_id = ? OR season_stats.season_id = ?", year1_id, year2_id)
                      .order(:player_id)

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

    mip = Player.find(top_player)
    mip_message = mip.first+" "+mip.last+" is the Most Improved Player from "+year1.to_s+" to "+year2.to_s+", with improvement: +"+top_avg.round(3).to_s
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
end
