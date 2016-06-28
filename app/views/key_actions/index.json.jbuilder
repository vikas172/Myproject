json.array!(@key_actions) do |key_action|
  json.extract! key_action, :id, :key_id, :action_type_id, :sequence, :say, :play, :dial, :record, :gather, :sms
  json.url key_action_url(key_action, format: :json)
end
