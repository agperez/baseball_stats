class Statsheet < ActiveRecord::Base
  belongs_to :season_stat
  belongs_to :player
  belongs_to :season
  belongs_to :team
  belongs_to :league

  def self.import_names
    CSV.foreach(Rails.root.join('app', 'assets', 'Master-small.csv'), headers: true) do |row|
      player = Player.find_by_importid(row["playerID"])
      player.update(first: row["nameFirst"], last: row["nameLast"]) unless player.nil?
    end
  end

  def self.import_stats
    CSV.foreach(Rails.root.join('app', 'assets', 'Batting-07-12.csv'), headers: true) do |row|

      games   = row["G"]    ==nil   ? 0 : row["G"].to_i
      ab      = row["AB"]   ==nil   ? 0 : row["AB"].to_i
      runs    = row["R"]    ==nil   ? 0 : row["R"].to_i
      hits    = row["H"]    ==nil   ? 0 : row["H"].to_i
      doubles = row["2B"]   ==nil   ? 0 : row["2B"].to_i
      triples = row["3B"]   ==nil   ? 0 : row["3B"].to_i
      hr      = row["HR"]   ==nil   ? 0 : row["HR"].to_i
      rbi     = row["RBI"]  ==nil   ? 0 : row["RBI"].to_i

      league  = row["league"]=='AL' ? 1 : 2


      team = Team.create_with(league_id: league)
                 .find_or_create_by(name: row["teamID"])

      player = Player.find_or_create_by(importid: row["playerID"])

      season = Season.find_or_create_by(year: row["yearID"])

      new_stat_sheet = false

      statsheet = Statsheet.find_or_create_by(player_id: player.id, team_id: team.id,
                                              season_id: season.id, games: games,
                                              league_id: league) do |sheet|
        sheet.ab               = ab
        sheet.runs             = runs
        sheet.hits             = hits
        sheet.doubles          = doubles
        sheet.triples          = triples
        sheet.hr               = hr
        sheet.rbi              = rbi
        sheet.sb               = row["SB"]
        sheet.cs               = row["CS"]

        new_stat_sheet = true
      end

      if new_stat_sheet

        new_season_stat = false

        ss = SeasonStat.find_or_create_by(player_id: player.id, season_id: season.id) do |stat|
          stat.games    = games
          stat.ab       = ab
          stat.runs     = runs
          stat.hits     = hits
          stat.doubles  = doubles
          stat.triples  = triples
          stat.hr       = hr
          stat.rbi      = rbi
          stat.avg      = (hits / ab.to_f)
          stat.slg      = (((hits-doubles-triples-hr)+(2*doubles)+(3*triples)+(4*hr))/ab.to_f)
          new_season_stat = true
        end

        statsheet.update(season_stat_id: ss.id)
        #statsheet.season_stat_id = ss.id
        #statsheet.save

        if !new_season_stat
          ss.games   += games
          ss.ab      += ab
          ss.runs    += runs
          ss.hits    += hits
          ss.doubles += doubles
          ss.triples += triples
          ss.hr      += hr
          ss.rbi     += rbi
          ss.avg     = (ss.hits / ss.ab.to_f)
          ss.slg     = (((ss.hits-ss.doubles-ss.triples-ss.hr)+(2*ss.doubles)+(3*ss.triples)+(4*ss.hr)) / ss.ab.to_f)

          ss.save
        end
      end
    end
  end
end
