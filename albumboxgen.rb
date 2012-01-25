require 'sinatra'
require 'active_support/all'
require 'scrobbler2'
GS_API_KEY = '0d01292c6827570c72a647903cc94e8b'
Scrobbler2::Base.api_key = GS_API_KEY

get '/' do
	@title = 'Album Box'
	erb :home
end

post '/' do
  @username=params[:username]
  @period= params[:period]
  begin
  @albums = get_data(@username,@period)
  rescue NoMethodError
  return erb :failed
  end
  erb :albumbox
end

get '/:cgi' do
  @username=params[:username]
  @period= params[:period]
  begin
  @albums = get_data(@username,@period)
  rescue NoMethodError
  return erb :failed
  end
  erb :albumbox
end

def get_data(username,period)
  user = Scrobbler2::User.new(username)
  
  albums = {
  :artist_names => [],
  :artist_urls  => [],
  :album_names  => [],
  :album_urls   => [],
  :image_urls   => []
  }
  top_albums = user.top_albums(nil,{:period => period,:limit=>"6"})["album"]
  top_albums.each do |a| 
	  albums[:artist_names] << a["artist"]["name"]
	  albums[:artist_urls]  << a["artist"]["url"]
	  albums[:album_names]  << a["name"]
	  albums[:album_urls]   << a["url"]
	  albums[:image_urls]   << a["image"][3]["#text"]
	end
  albums
end