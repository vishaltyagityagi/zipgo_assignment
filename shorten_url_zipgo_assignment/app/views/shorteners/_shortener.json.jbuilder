json.extract! shortener, :id, :url, :shorten_url, :created_at, :updated_at
json.url shortener_url(shortener, format: :json)
