json.array!(@links) do |link|
  json.extract! link, :id, :url, :value
  json.url link_url(link, format: :json)
end
