require 'lolspeak'
require 'hpricot'

class TweetsController < ApplicationController
  def show
    response = Net::HTTP.get_response(URI.parse("http://api.cheezburger.com/xml/category/cats/lol/random"))
    doc = Hpricot::XML(response.body)
    @catimage = (doc/:PictureImageUrl).innerHTML
    
    render :new
  end
  def new
    
  end
  
  def create
    
    #still needs to check the image size and set x,y based on that
    #still needs to check caption length and break it up to fit on the image
    #still needs to generate and submit to cb api
    #still needs to load xml, I think that would be cleaner
    #still needs to persist the caption data xml so that when the user submits we can use that to send the content to cb api and generate tweet from the resulting content
    
    
    @loltweet = params[:tweet].to_lolspeak
    @imageurl = params[:original_image_url] # this should be set to the url resulting from pushing content to cb api
    
    # if we want to use bitly
    # uri = URI.parse("http://api.bit.ly/v3/shorten?login=&apikey=&longUrl=#{params[:original_image_url]}%2F&format=txt")
    #    response = Net::HTTP.get_response(uri)
    #    @imageurl = response.body.strip
    
    xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><CaptionData><OriginalImageUrl>#{params[:original_image_url]}</OriginalImageUrl><Captions><Caption><Text>#{@loltweet}</Text><FontFamily>Impact</FontFamily><FontSize>40</FontSize><FontColor>white</FontColor><XPosition>80</XPosition><YPosition>50</YPosition><IsBold>false</IsBold><TextStyle>outline</TextStyle><IsItalic>false</IsItalic><IsStrikeThrough>false</IsStrikeThrough><IsUnderLine>false</IsUnderLine><Opacity>100</Opacity></Caption></Captions></CaptionData>"

    #POST to: http://cheezburger.com/caption/previewcaption.ashx
    
     # xml = string.multiline do
     #  "<?xml version='1.0' encoding='utf-8'?>"
     #  "<CaptionData>"
     #    "<OriginalImageUrl>" + params[:original_image_url] + "</OriginalImageUrl>"
     #    "<Captions>"
     #      "<Caption>"
     #        "<Text>" + @loltweet + "</Text>"
     #        "<FontFamily>Impact</FontFamily>"
     #        "<FontSize>40</FontSize>"
     #        "<FontColor>white</FontColor>"
     #        "<XPosition>80</XPosition>"
     #        "<YPosition>205</YPosition>"
     #        "<IsBold>false</IsBold>"
     #        "<TextStyle>outline</TextStyle>"
     #        "<IsItalic>false</IsItalic>"
     #        "<IsStrikeThrough>false</IsStrikeThrough>"
     #        "<IsUnderLine>false</IsUnderLine>"
     #        "<Opacity>100</Opacity>"
     #      "</Caption>"
     #    "</Captions>"
     #  "</CaptionData>"
     #  end
    
    @previewimage = "http://cheezburger.com/caption/previewcaption.ashx?" + CGI.escape(xml)
    
  end
end