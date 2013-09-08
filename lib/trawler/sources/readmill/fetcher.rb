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

        def highlights_for_user(user_id, count=100)
          highlights_json = get_json("https://api.readmill.com/v2/users/#{user_id}/highlights?client_id=#{@client_id}&count=#{count}") {|error_response| raise "Fetch of Readmill highlights for user #{user_id} failed. #{error_response}" }

          @parser.highlights_from_json(highlights_json)
        end

        def book_for_reading(reading_id)
          reading_json = get_json("https://api.readmill.com/v2/readings/#{reading_id}?client_id=#{@client_id}") {|error_response| raise "Fetch of Readmill reading #{reading_id} failed. #{error_response}" }

          @parser.book_from_reading_json(reading_json)
        end

      private

        def get_json(url)
          response = RestClient.get(url, { accepts: :json })

          yield(response) unless response.code == 200

          JSON.parse(response.body)
        end
      end
    end
  end
end

