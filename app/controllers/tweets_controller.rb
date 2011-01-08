require 'lolspeak'

class TweetsController < ApplicationController
  def show
    render :new
  end
  def new
    
  end
  
  def create
    @loltweet = params[:tweet].to_lolspeak
  end
end