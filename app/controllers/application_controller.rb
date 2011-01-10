class ApplicationController < ActionController::Base
  protect_from_forgery
  CONSUMER_KEY = 'eFv13CgYgUamtEqjViixQ'
  CONSUMER_SECRET = 'MSu32M0rSFP2WgHDlRf2d4q8Wr9AKg1uHYs8UGOHA'
  attr_writer :twitter_client
  
  def twitter_client
    if @twitter_client.nil? and session[:twitter_access_token].nil?
      @twitter_client = TwitterOAuth::Client.new(:consumer_key => CONSUMER_KEY, :consumer_secret => CONSUMER_SECRET)
    else
      @twitter_client = TwitterOAuth::Client.new(:consumer_key => CONSUMER_KEY, 
                                                 :consumer_secret => CONSUMER_SECRET,
                                                 :token => session[:twitter_access_token],
                                                 :secret => session[:twitter_access_secret])
    end
    @twitter_client
  end
end
