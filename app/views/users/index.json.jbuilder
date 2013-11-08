json.array!(@users) do |user|
  json.extract! user, :done, :admin, :username, :email
  json.url user_url(user, format: :json)
end
