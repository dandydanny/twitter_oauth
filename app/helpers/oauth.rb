def oauth_consumer
  raise RuntimeError, "You must set TWITTER_KEY and TWITTER_SECRET in your server environment." unless ENV['TWITTER_KEY'] and ENV['TWITTER_SECRET']
  @consumer ||= OAuth::Consumer.new(
    ENV['TWITTER_KEY'],
    ENV['TWITTER_SECRET'],
    :site => "https://api.twitter.com"
  )
end

def request_token
  puts "============= def request_token. session[:request_token] is =============="
  p session[:request_token]
  if not session[:request_token]
    # this 'host_and_port' logic allows our app to work both locally and on Heroku
    host_and_port = request.host
    host_and_port << ":9393" if request.host == "localhost"
    puts "=========== getting a token from Twitter ===================="
    # the `oauth_consumer` method is defined above
    session[:request_token] = oauth_consumer.get_request_token(
      # After user grants access, redirect to /auth
      :oauth_callback => "http://#{host_and_port}/auth"
    )
  end
  puts "========== after requets_token method, session[:request_token] is... =========="
  p session[:request_token]
  session[:request_token]
end
