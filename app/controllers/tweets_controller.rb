require 'lolspeak'
require 'hpricot'

class TweetsController < ApplicationController
  def show
    flash[:error] = nil
    response = Net::HTTP.get_response(URI.parse("http://api.cheezburger.com/xml/category/cats/lol/random"))
    doc = Hpricot::XML(response.body)
    @catimage = (doc/:PictureImageUrl).innerHTML
    @pictureId = (doc/:PictureId).innerHTML
    
    render :new
  end
  def new
    
  end
  
  def preview
    if params[:tweet].to_lolspeak.length > 125
      flash[:error] = "Your tweet was too long and has to be truncated"
    end
    @loltweet = params[:tweet].to_lolspeak[0..124]
    @imageurl = params[:original_image_url] # this should be set to the url resulting from pushing content to cb api
    @pictureId = params[:picture_id] # this is the picture ID to send to cheeseburger
    
    xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><CaptionData><OriginalImageUrl>#{params[:original_image_url]}</OriginalImageUrl><Captions><Caption><Text>#{parse_tweet_text(@loltweet)}</Text><FontFamily>Impact</FontFamily><FontSize>40</FontSize><FontColor>white</FontColor><XPosition>80</XPosition><YPosition>50</YPosition><IsBold>false</IsBold><TextStyle>outline</TextStyle><IsItalic>false</IsItalic><IsStrikeThrough>false</IsStrikeThrough><IsUnderLine>false</IsUnderLine><Opacity>100</Opacity></Caption></Captions></CaptionData>"

    
    @previewimage = "http://cheezburger.com/caption/previewcaption.ashx?" + CGI.escape(xml)
  end
  
  def create
    
    @loltweet = parse_tweet_text(params[:lol_tweet])
    @imageurl = params[:original_image_url] # this should be set to the url resulting from pushing content to cb api
    @pictureId = params[:picture_id] # this is the picture ID to send to cheeseburger
    
    xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><CaptionedLol><FullText>#{@loltweet}</FullText><PictureId>#{@pictureId}</PictureId><Title>Tweet Burger</Title><Description></Description><EmailAddress></EmailAddress><Name></Name><CaptionData><OriginalImageUrl>#{@imageurl}</OriginalImageUrl><Captions><Caption><Text>#{@loltweet}</Text><FontFamily>Impact</FontFamily><FontSize>30</FontSize><FontColor>White</FontColor><XPosition>10</XPosition><YPosition>20</YPosition><IsBold>false</IsBold><TextStyle>outline</TextStyle><IsItalic>false</IsItalic><IsStrikeThrough>false</IsStrikeThrough><IsUnderLine>false</IsUnderLine><Opacity>100</Opacity></Caption></Captions></CaptionData></CaptionedLol>"

    #post the lol caption to cheeseburger and hopefully get an image back
    url = URI.parse('http://api.cheezburger.com/xml/lol')
    request = Net::HTTP::Post.new(url.path)
    request.body = xml
    request["DeveloperKey"] = APP_CONFIG["cheezburger_key"]
    request["ClientID"] = APP_CONFIG["cheezburger_clientid"]
    request.content_type = 'text/xml'
    response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}
    doc = Hpricot::XML(response.body)
 
    # if we want to use bitly
    uri = URI.parse("http://api.bit.ly/v3/shorten?login=#{APP_CONFIG["bitly_username"]}&apikey=#{APP_CONFIG["bitly_token"]}&longUrl=#{(doc/:LolImageUrl).innerHTML}&format=txt")
    response = Net::HTTP.get_response(uri)
    bitlyImage = response.body.strip
    
    #post to twitter
    twitter_text = "#{@loltweet} : #{bitlyImage} #tweetburger"
    twitter_client.update(twitter_text)
    
    redirect_to tweet_path
    
  end

  private
  def parse_tweet_text(tweet_text)
    
    # split the text into an array by the spacebar to see if there are more than 4 words
    tweet_text_array = tweet_text.split(' ')
    return_text = ''  # the return text
    wrap_count = 0 # local variable for count
      
    # loop through the text array
    tweet_text_array.each do |text|
        
      return_text = "#{return_text} #{text}"

      # if the wrap count is 3 then we are going to break here        
      if wrap_count == 3
        return_text = "#{return_text}\r\n" 
        wrap_count = 0
      end
        
      wrap_count = wrap_count + 1
    end
    return return_text
  end

end