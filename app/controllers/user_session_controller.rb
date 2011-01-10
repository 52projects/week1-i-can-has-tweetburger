class UserSessionController < ApplicationController
  def login
    req_token = twitter_client.request_token(:oauth_callback => 'http://icanhastweetburger.heroku.com/callback')
    session[:twitter_request_token] = req_token.token
    session[:twitter_request_secret] = req_token.secret

    redirect_to req_token.authorize_url
  end

  def callback
    self.twitter_client = twitter_client.authorize(session[:twitter_request_token], session[:twitter_request_secret], :oauth_verifier => params[:oauth_verifier])
    if twitter_client.authorized?
      session[:twitter_request_token] = nil
      session[:twitter_request_secret] = nil
      session[:twitter_access_token] = @twitter_client.token
      session[:twitter_access_secret] = @twitter_client.secret
      redirect_to '/tweet'
    else
      flash[:error] = "Invalid username or password"
      #redirect_to '/login'
    end
  end

end
