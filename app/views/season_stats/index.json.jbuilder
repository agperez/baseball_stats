json.array!(@season_stats) do |season_stat|
  json.extract! season_stat, :id, :games, :ab, :runs, :hits, :doubles, :triples, :hr, :rbi, :sb, :cs
  json.url season_stat_url(season_stat, format: :json)
end
