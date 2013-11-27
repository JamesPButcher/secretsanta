json.array!(@people) do |person|
  json.extract! person, :name, :email, :giving_to_id, :receiving_from_id
  json.url person_url(person, format: :json)
end
