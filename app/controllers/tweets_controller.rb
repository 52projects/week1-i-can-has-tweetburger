require 'lolspeak'
require 'hpricot'

class TweetsController < ApplicationController
  def show
    response = Net::HTTP.get_response(URI.parse("http://api.cheezburger.com/xml/category/cats/lol/random"))
    doc = Hpricot::XML(response.body)
    @catimage = (doc/:PictureImageUrl).innerHTML
    
    render :new
  end
  def new
    
  end
  
  def create
    @loltweet = params[:tweet].to_lolspeak
    
  end
end