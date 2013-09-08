require 'lastfm'

module Trawler
  module Sources
    module Lastfm
      class Source
        def self.collect(lastfm_key, lastfm_username)
          lastfm = ::Lastfm.new(lastfm_key, '')
          fetcher = Fetcher.new(Stores::Lastfm::Track, lastfm)
          lastfm_tracks = fetcher.fetch(lastfm_username)
          Parser.parse(lastfm_tracks)
        end
      end
    end
  end
end
