json.array!(@players) do |player|
  json.extract! player, :id, :first, :last
  json.url player_url(player, format: :json)
end
