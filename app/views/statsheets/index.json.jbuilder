json.array!(@statsheets) do |statsheet|
  json.extract! statsheet, :id, :games, :ab, :runs, :hits, :doubles, :triples, :hr, :rbi, :sb, :cs
  json.url statsheet_url(statsheet, format: :json)
end
