class UserSessionController < ApplicationController
  skip_before_filter :check_auth
  
  def index
    
  end
  
  def login
    if cookies[:tkeys]
      u = UserSession.find_by_identifier(cookies[:tkeys])
      session[:twitter_access_token] = u.access_token
      session[:twitter_access_secret] = u.access_secret
      
      redirect_to tweet_path
    else
      req_token = twitter_client.request_token(:oauth_callback => 'http://icanhastweetburger.heroku.com/callback')
      session[:twitter_request_token] = req_token.token
      session[:twitter_request_secret] = req_token.secret

      redirect_to req_token.authorize_url
    end
  end
  
  def logoff
    reset_session
    cookies.delete(:tkeys)
  end

  def callback
    access_token = twitter_client.authorize(session[:twitter_request_token], session[:twitter_request_secret], :oauth_verifier => params[:oauth_verifier])
    if not access_token.nil?
      session[:twitter_access_token] = access_token.token
      session[:twitter_access_secret] = access_token.secret
      twitter_identifier = Digest::SHA1.hexdigest Time.now.to_s
      cookies[:tkeys] = {:value => twitter_identifier,
                         :expires => 1.year.from_now }
      u = UserSession.new(:identifier => twitter_identifier, :access_token => access_token.token, :access_secret => access_token.secret)
      u.save
    end
    @twitter_client = nil
    if twitter_client.authorized?
      session[:twitter_request_token] = nil
      session[:twitter_request_secret] = nil
      
      redirect_to '/tweet'
    else
      redirect_to '/login'
    end
  end

end
