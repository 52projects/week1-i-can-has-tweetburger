class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_auth
  
  CONSUMER_KEY = APP_CONFIG['twitter_consumer_key']
  CONSUMER_SECRET = APP_CONFIG['twitter_consumer_secret']
  attr_writer :twitter_client
  
  def twitter_client
    if cookies[:tkeys]
      u = UserSession.find_by_identifier(cookies[:tkeys])
      session[:twitter_access_token] = u.access_token
      session[:twitter_access_secret] = u.access_secret
    end
    
    if @twitter_client.nil? and session[:twitter_access_token].nil?
      @twitter_client = TwitterOAuth::Client.new(:consumer_key => CONSUMER_KEY, :consumer_secret => CONSUMER_SECRET)
    else session[:twitter_access_token]
      @twitter_client = TwitterOAuth::Client.new(:consumer_key => CONSUMER_KEY, 
                                                 :consumer_secret => CONSUMER_SECRET,
                                                 :token => session[:twitter_access_token],
                                                 :secret => session[:twitter_access_secret])
    end
    @twitter_client
  end
  
  private
  
  def check_auth
    if not twitter_client.authorized?
      redirect_to login_path
    end
  end
  
end
