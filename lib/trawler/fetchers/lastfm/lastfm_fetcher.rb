module Trawler
  module Fetchers
    class LastfmFetcher
      def initialize(lastfm, store)
        @lastfm = lastfm
        @store = store
      end

      def fetch(username)
        options = { :limit => 200 }
        options.merge!(:from => @store.latest_timestamp) if @store.latest_timestamp

        result = @lastfm.get_recent_tracks(username, options)
        tracks = result['track']

        total_pages = result['totalPages'].to_i if result['totalPages']

        if total_pages and total_pages > 1
          (2..total_pages).each do |page|
            tracks += @lastfm.get_recent_tracks(username, options.merge(:page => page))['track']
          end
        end

        tracks
      end
    end
  end
end
