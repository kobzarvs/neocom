json.array!(@attributes) do |attribute|
  json.extract! attribute, :id, :name, :node_id
  json.url attribute_url(attribute, format: :json)
end
