class ApplicationController < ActionController::Base
  protect_from_forgery
  
  attr_writer :twitter_client
  
  def twitter_client
    if @twitter_client.nil? and session[:twitter_access_token].nil?
      @twitter_client = TwitterOAuth::Client.new(:consumer_key => 'BmJSrMVJOX4fRdddKxbuug', :consumer_secret => 'zu1EP6RICEKWcygg0QSVbcnVlaXbZQeyLpdRDjpxHU')
    else
      @twitter_client = TwitterOAuth::Client.new(:consumer_key => 'BmJSrMVJOX4fRdddKxbuug', 
                                                 :consumer_secret => 'zu1EP6RICEKWcygg0QSVbcnVlaXbZQeyLpdRDjpxHU',
                                                 :token => session[:twitter_access_token],
                                                 :secret => session[:twitter_access_secret])
    end
    @twitter_client
  end
end
