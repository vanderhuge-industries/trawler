require 'httparty'

module Trawler
  module Sources
    module Readmill
      class Fetcher
        def initialize(client_id, parser=Parser.new)
          @client_id = client_id
          @parser = parser
        end

        def highlights_for_user(user_id, count=100)
          response = HTTParty.get "https://api.readmill.com/v2/users/#{user_id}/highlights?client_id=#{@client_id}&count=#{count}"

          raise "Fetch of Readmill highlights failed. #{response}" unless response.code == 200

          @parser.call(response.parsed_response)
        end
      end
    end
  end
end

