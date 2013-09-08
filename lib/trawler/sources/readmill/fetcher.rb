require 'rest-client'
require 'json'

module Trawler
  module Sources
    module Readmill
      class Fetcher
        def initialize(client_id, parser=Parser.new)
          @client_id = client_id
          @parser = parser
        end

        def highlights_for_user(user_id, count=100, fetch_all=false)
          response = RestClient.get "https://api.readmill.com/v2/users/#{user_id}/highlights?client_id=#{@client_id}&count=#{count}"

          raise "Fetch of Readmill highlights failed. #{response}" unless response.code == 200

          @parser.highlights_from_json(JSON.parse response.body)
        end
      end
    end
  end
end

