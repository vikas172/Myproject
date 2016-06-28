json.array!(@action_types) do |action_type|
  json.extract! action_type, :id, :name

end
