require 'memoist'

module Trawler
  module Sources
    module Readmill
      class Fetcher
        extend Memoist

        def initialize(client_id, parser=Parser.new)
          @client_id = client_id
          @parser = parser
        end

        def all_highlights_for_user(user_id)
          highlights, next_page_url = fetch_highlights(highlights_url(user_id, 100))
          result = highlights

          while next_page_url
            highlights, next_page_url = fetch_highlights(next_page_url)
            result.concat highlights
          end

          result
        end

        def highlights_for_user(user_id, count=100)
          highlights, _ = fetch_highlights(highlights_url(user_id, count))
          highlights
        end

        def book_for_reading(reading_id)
          reading_json = Trawler::Sources::JsonFetcher.get(reading_url(reading_id)) do |error_response|
            raise "Fetch of Readmill reading #{reading_id} failed. #{error_response}"
          end

          @parser.book_from_reading_json(reading_json)
        end

      private

        def fetch_highlights(url)
          highlights_json = Trawler::Sources::JsonFetcher.get(url) do |error_response|
            raise "Fetch of Readmill highlights from #{url} failed. #{error_response}"
          end
          next_page_url = highlights_json["pagination"]["next"]

          [@parser.highlights_from_json(highlights_json), next_page_url]
        end

        def highlights_url(user_id, count)
          "https://api.readmill.com/v2/users/#{user_id}/highlights?client_id=#{@client_id}&count=#{count}"
        end

        def reading_url(reading_id)
          "https://api.readmill.com/v2/readings/#{reading_id}?client_id=#{@client_id}"
        end
      end
    end
  end
end

