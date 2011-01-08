require 'lolspeak'

class TweetsController < ApplicationController
  def new
    
  end
  
  def create
    @loltweet = params[:tweet].to_lolspeak
  end
end