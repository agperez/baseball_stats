class Statsheet < ActiveRecord::Base
  belongs_to :season_stat
  belongs_to :player
  belongs_to :season
  belongs_to :team
  belongs_to :league

  def self.import_stats
    CSV.foreach(Rails.root.join('app', 'assets', 'statmaster.csv'), headers: true) do |row|

      games   = if row["G"]   ==nil then 0 else row["G"]    end
      ab      = if row["AB"]  ==nil then 0 else row["AB"]   end
      runs    = if row["R"]   ==nil then 0 else row["R"]    end
      hits    = if row["H"]   ==nil then 0 else row["H"]    end
      doubles = if row["2B"]  ==nil then 0 else row["2B"]   end
      triples = if row["3B"]  ==nil then 0 else row["3B"]   end
      hr      = if row["HR"]  ==nil then 0 else row["HR"]   end
      rbi     = if row["RBI"] ==nil then 0 else row["RBI"]  end

      if row["league"] == 'AL'
        leauge = 1
      else
        league = 2
      end

      team = Team.create_with(league_id: league)
                 .find_or_create_by(name: row["teamID"])

      player = Player.find_or_create_by(importid: row["playerID"])

      season = Season.find_or_create_by(year: row["yearID"])

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
      end

      new_season_stat = false

      season_stat = SeasonStat.find_or_create_by(player_id: player.id, season_id: season.id) do |stat|
        stat.games    = statsheet.games
        stat.ab       = statsheet.ab
        stat.runs     = statsheet.runs
        stat.hits     = statsheet.hits
        stat.doubles  = statsheet.doubles
        stat.triples  = statsheet.triples
        stat.hr       = statsheet.hr
        stat.rbi      = statsheet.rbi

        new_season_stat = true
      end

      if !new_season_stat
        season_stat.games   += statsheet.games
        season_stat.ab      += statsheet.ab
        season_stat.runs    += statsheet.runs
        season_stat.hits    += statsheet.hits
        season_stat.doubles += statsheet.doubles
        season_stat.triples += statsheet.triples
        season_stat.hr      += statsheet.hr
        season_stat.rbi     += statsheet.rbi
        season_stat.avg     = statsheet.hits / statsheet.ab

        season_stat.save
      end



      # if season_stat.nil?
      #   SeasonStat.create_by(player_id: player.id, season_id: season.id) do |stat|
      #     stat.games           = row["G"]   || 0
      #     stat.ab              = row["AB"]  || 0
      #     stat.runs            = row["R"]   || 0
      #     stat.hits            = row["H"]   || 0
      #     stat.doubles         = row["2B"]  || 0
      #     stat.triples         = row["3B"]  || 0
      #     stat.hr              = row["HR"]  || 0
      #     stat.rbi             = row["RBI"] || 0
      #     stat.sb              = row["SB"]  || 0
      #     stat.cs              = row["CS"]  || 0
      #   end
      #
      # else
      #   season_stat.games      += row["G"]
      #   season_stat.ab         += row["AB"]
      #   season_stat.runs       += row["R"]
      #   season_stat.hits       += row["H"]
      #   season_stat.doubles    += row["2B"]
      #   season_stat.triples    += row["3B"]
      #   season_stat.hr         += row["HR"]
      #   season_stat.rbi        += row["RBI"]
      #   season_stat.sb         += row["SB"]
      #   season_stat.cs         += row["CS"]
      # end
    end
  end
end
