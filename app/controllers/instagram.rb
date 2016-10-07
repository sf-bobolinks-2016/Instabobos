
#  Here your call bacl
CALLBACK_URL = "http://localhost:9393/auth/callback"


# Here your cerdentials that you can pass from the ENV
Instagram.configure do |config|
  config.client_id = "2b089c3e792e413e83df3a594320373c"
  config.client_secret = "9302a2b100ae4494a8d43c65d2fb1053"
  # For secured endpoints only
  #config.client_ips = '<Comma separated list of IPs>'
end

get "/" do
  '<a href="/auth/connect"><img src="http://i.kinja-img.com/gawker-media/image/upload/t_original/ijmyfpjavgey76pyxnft.jpg"></a>'
end

get "/auth/connect" do
  # Redirects to instagram OAuth URL and passes the your callback
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

# This one need to match
get "/auth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)

  p "######### accsess_token ##############"
  p response.access_token
  p "--------------------------------------"

  session[:access_token] = response.access_token
  redirect "/user_recent_media"
end

get "/user_recent_media" do
  client = Instagram.client(:access_token => session[:access_token])
  user = client.user
  html = "<h1>#{user.username}'s recent media</h1>"
  for media_item in client.user_recent_media
    html << "<div style='float:left;'><img src='#{media_item.images.thumbnail.url}'></div>"
  end
  html
end