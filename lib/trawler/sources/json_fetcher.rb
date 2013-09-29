require 'rest-client'
require 'json'
require 'memoist'

module Trawler
  module Sources
    class JsonFetcher

      class << self
        extend Memoist

        def get(url)
          puts "Fetching #{url} ..."
          response = RestClient.get(url, { accepts: :json })

          yield(response) unless response.code == 200

          JSON.parse(response.body)
        end

        memoize :get
      end
    end
  end
end

