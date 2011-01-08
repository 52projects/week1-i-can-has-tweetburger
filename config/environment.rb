# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Icanhastweetburger::Application.initialize!

# Twitter OAuth settings
TWOAUTH_SITE = 'http://twitter.com'
# Twitter OAuth callback default
TWOAUTH_CALLBACK = ENV['TWOAUTH_CALLBACK']
# Twitter OAuth Consumer key
TWOAUTH_KEY = ENV['TWOAUTH_KEY']
# Twitter OAuth Consumer secret
TWOAUTH_SECRET = ENV['TWOAUTH_SECRET']