require 'readit'

# Doing the OAuth dance is just no fun.
module Readit
  class API
    def self.authenticate(app_key, app_secret, username, password)
      Readit::Config.consumer_key = app_key
      Readit::Config.consumer_secret = app_secret

      xauth_args = {
        :x_auth_mode => 'client_auth',
        :x_auth_username => username,
        :x_auth_password => password
      }

      oauth_consumer = ::OAuth::Consumer.new(
        Readit::Config.consumer_key,
        Readit::Config.consumer_secret,
        :site => "https://www.readability.com/",
        :access_token_path => "/api/rest/v1/oauth/access_token/")

      access_token = oauth_consumer.get_access_token(nil, { }, xauth_args)

      self.new(access_token.token, access_token.secret)
    end
  end
end

