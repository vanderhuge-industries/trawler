require 'rest-client'
require 'json'
require 'memoist'

module Trawler
  module Sources
    class JsonFetcher

      class << self
        extend Memoist

        def get(url, &error_block)
          error_block ||= -> r { raise "Fetch of #{url} failed. #{error_response}" }

          puts "Fetching #{url} ..."
          response = RestClient.get(url, { accepts: :json })

          error_block.call(response) unless response.code == 200

          JSON.parse(response.body)
        end

        memoize :get
      end
    end
  end
end

