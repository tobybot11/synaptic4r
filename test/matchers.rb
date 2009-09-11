####------------------------------------------------------------------------------------------------------
def_matcher :send_request do |receiver, matcher, args|
  matched, exp = true, args.first
  pos_msg, neg_msg = '', ''
  unless exp[:url].eql?(receiver.url) 
    pos_msg << "Expected 'url' of #{exp[:url]}, but found #{receiver.url}\n"
    matched = false
  end
  unless exp[:payload].eql?(receiver.payload)
    pos_msg << "Expected 'payload' of #{exp[:payload]}, but found #{receiver.payload}\n"
    matched = false
  end
  unless exp[:http_request].eql?(receiver.http_request)
    pos_msg << "Expected 'http_request' of #{exp[:http_request]}, but found #{receiver.http_request}\n"
    matched = false
  end
  matcher.positive_msg = pos_msg
  matched
end
