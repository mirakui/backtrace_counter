json.array!(@products) do |product|
  json.extract! product, :name
  json.url product_url(product, format: :json)
end
