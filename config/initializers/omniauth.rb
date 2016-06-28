Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :stripe_connect,'ca_5cwc059rXUAhRIwQsJOy4lYs5QNHVbeW', "sk_test_U6G24ByG5AHG771FbQWh7w1n",:stripe_landing => 'register'
  provider :stripe_connect,'ca_7zjeUW6QxNWRhd1OhX8ZGL3TSgO4CgMw', "sk_test_U6G24ByG5AHG771FbQWh7w1n",:stripe_landing => 'register'
end