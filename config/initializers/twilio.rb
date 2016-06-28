# # Client second time given Creditail
# Twilio.configure do |config|
#   config.account_sid = "ACd869a002f0e70e88052135df47fbcc3f"
#   config.auth_token = "af4736a568708a4bd4e5735b3c3f5fec"
#   # config.app_sid ="APd802f77727ee13770aba579fd9e94f38"
# end

# #prateek.yuvasoft101@gmail.com Creditail

# # Twilio.configure do |config|
# #   config.account_sid = "ACe8ce31cb94b7ff8a5f551a533b865ef9"
# #   config.auth_token = "a2dc7add9b324d7c2a352b0ae785bec9"
# # end


require 'twilio-ruby'

# # put your own credentials here
# # $account_sid = 'AC8f6b581e1381cb405ca1735a6900f524'
# # $auth_token = 'a5f7ae43162029c9e6bc1c7cc1f643b8'
# #$click_to_call_app = 'AP98ca75b453141603fa76d7db706ac12e'
# $account_sid = 'AC8f6b581e1381cb405ca1735a6900f524'
# $auth_token  = 'a5f7ae43162029c9e6bc1c7cc1f643b8'
# # set up a client to talk to the Twilio REST API

# TWILIO CRED ganesh@aspectsolutions.com
$account_sid = 'ACc9f73b6f8004cbfb90ef93a574504d6b'
$auth_token = 'e97bcc7b5369bf231d778b0cdc489e77'
$twilio_client = Twilio::REST::Client.new $account_sid, $auth_token
