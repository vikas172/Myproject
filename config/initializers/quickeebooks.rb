# QB_KEY = "qyprdA8g1YKPQM2ADj5qxr9JhB108C"
# QB_SECRET = "ViLq3RcqJjEIqFjwMF2dV9dpqteOL2fdBIOvC03e"

# QB_KEY= "qyprdb7kIfawqV7KAb5pKbdUybUK4f"
# QB_SECRET = "ZZek8n66Q7yGVDZS3aIHnixIjulIPbsCI1oenPgR"
# $qb_oauth_consumer = OAuth::Consumer.new(QB_KEY, QB_SECRET, {
# 	:site                 => "https://oauth.intuit.com",
# 	:request_token_path   => "/oauth/v1/get_request_token",
# 	:authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
# 	:access_token_path    => "/oauth/v1/get_access_token"
# })



# QB_KEY= "qyprdjnXte1IJjdDIBTrzgL5X78biL"
# QB_SECRET = "WFdZUfijqe148HQcjQElpYvm1UxhcUhXenmojnFh"
# $qb_oauth_consumer = OAuth::Consumer.new(QB_KEY, QB_SECRET, {
# 	:site                 => "https://oauth.intuit.com",
# 	:request_token_path   => "/oauth/v1/get_request_token",
# 	:authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
# 	:access_token_path    => "/oauth/v1/get_access_token"
# })

QB_KEY= "qyprdOybbCGiKWOBRyPtqq5Xhch6Zy"
QB_SECRET = "g33Gy5qSf8bqnz66aMhmZFH56pKNlAs4WfC9L4ia"
$qb_oauth_consumer = OAuth::Consumer.new(QB_KEY, QB_SECRET, {
	:site                 => "https://oauth.intuit.com",
	:request_token_path   => "/oauth/v1/get_request_token",
	:authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
	:access_token_path    => "/oauth/v1/get_access_token"
})

Quickbooks.sandbox_mode = true

