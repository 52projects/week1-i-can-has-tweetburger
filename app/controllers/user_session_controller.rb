class UserSessionController < ApplicationController
  skip_before_filter :check_auth
  
  def login
    req_token = twitter_client.request_token(:oauth_callback => 'http://icanhastweetburger.heroku.com/callback')
    session[:twitter_request_token] = req_token.token
    session[:twitter_request_secret] = req_token.secret

    redirect_to req_token.authorize_url
  end
  
  def logoff
    reset_session
  end

  def callback
    access_token = twitter_client.authorize(session[:twitter_request_token], session[:twitter_request_secret], :oauth_verifier => params[:oauth_verifier])
    if not access_token.nil?
      session[:twitter_access_token] = access_token.token
      session[:twitter_access_secret] = access_token.secret
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
