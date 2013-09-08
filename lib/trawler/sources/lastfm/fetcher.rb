module Trawler
  module Sources
    module Lastfm
      class Fetcher
        def initialize(store, lastfm)
          @store = store
          @lastfm = lastfm
        end

        def fetch(username)
          options = { :user => username, :limit => 200 }
          options.merge!(:from => @store.latest_timestamp) if @store.latest_timestamp

          result = @lastfm.user.get_recent_tracks(options)
          tracks = result['track']

          total_pages = result['totalPages'].to_i if result['totalPages']

          if total_pages and total_pages > 1
            (2..total_pages).each do |page|
              tracks += @lastfm.user.get_recent_tracks(options.merge(:page => page))['track']
            end
          end

          tracks
        end
      end
    end
  end
end
