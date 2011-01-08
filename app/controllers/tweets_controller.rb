require 'lolspeak'

class TweetsController < ApplicationController
  def show
    
    render :new
  end
  def new
    
  end
  
  def create
    #http://api.cheezburger.com/xml/category/cats/lol/random
    uri = URI.parse("http://api.cheezburger.com/xml/category/cats/lol/random")
    response = Net::HTTP.get_response(uri)
    
    @catimage = response.body
    
    
    @loltweet = params[:tweet].to_lolspeak
    
  end
end