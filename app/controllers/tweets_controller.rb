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
    
    @loltweet = params[:tweet].to_lolspeak
    
    #POST to: http://cheezburger.com/caption/previewcaption.ashx
    #URI.escape()
    xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><CaptionData><OriginalImageUrl>" + params[:original_image_url] + "</OriginalImageUrl><Captions><Caption><Text>" + @loltweet + "</Text><FontFamily>Impact</FontFamily><FontSize>40</FontSize><FontColor>white</FontColor><XPosition>80</XPosition><YPosition>50</YPosition><IsBold>false</IsBold><TextStyle>outline</TextStyle><IsItalic>false</IsItalic><IsStrikeThrough>false</IsStrikeThrough><IsUnderLine>false</IsUnderLine><Opacity>100</Opacity></Caption></Captions></CaptionData>"

    
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