module Trawler
  module Fetchers
    class LastfmFetcher
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

        # TODO: Map these to a local model?
        # - it would be more resilient to API changes and be a nice
        #   entry point for persistence.
        tracks
      end
    end
  end
end
