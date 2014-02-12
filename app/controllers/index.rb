get '/' do
  erb :index
end

get '/sign_in' do
  puts " ++++++++++++++++ signing in ++++++++++++++++++++++"
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  puts " ++++++++++++++++ signing out ++++++++++++++++++++++"
  session.clear
  redirect '/'
end





get '/auth' do
  puts " ++++++++++++++++ in /auth route ++++++++++++++++++++++"
  puts params[:oauth_verifier]
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  # Request ACCESS TOKEN from twitter
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  puts "----------------- Inside access token....------------"
  # p @access_token

  # our request token is only valid until we use it to get an access token, so let's delete it from our session

  puts "session is ... ----------------------------------"
  # p session[:access_token]

  # at this point in the code is where you'll need to create your user account and store the access token
  # p @access_token.params[:screen_name]
  # create new user
  # set her as logged in
  # store access token and secret along with her user record, etc.

  # Create or find user....
  @user = User.find_or_create_by(username: @access_token.params[:screen_name])

  #... but forefully update oauth keys each time
  @user.update(oauth_token: @access_token.token,
               oauth_secret: @access_token.secret)

  # commit changes
  @user.save

  session.delete(:request_token)
  session[:access_token] = @access_token

  session[:user_id] = @user.id
  puts "-------------------------- end of /auth --------------------------"
  erb :index
end


post '/tweet' do
  puts " ++++++++++++++++ in /tweet route ++++++++++++++++++++++"
  puts "client is........"
  # p CLIENT.all
  # p CLIENT.update(params["tweet"]).text
  t = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['TWITTER_KEY']
    config.consumer_secret = ENV['TWITTER_SECRET']
    config.access_token        = session[:access_token].params[:oauth_token]
    config.access_token_secret = session[:access_token].params[:oauth_token_secret]
  end
  puts "-------------- param['tweet'] is... --------------------"
  p params["tweet"]
  t.update(params["tweet"]) # params['tweet'] = key['value']
end
