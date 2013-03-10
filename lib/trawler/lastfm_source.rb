require 'lastfm'

module Trawler
  class LastfmSource
    def self.collect(lastfm_key, lastfm_username)
      lastfm = Lastfm.new(lastfm_key)
      fetcher = Fetchers::LastfmFetcher.new(Stores::Lastfm::Track, lastfm)
      lastfm_tracks = fetcher.fetch(lastfm_username)
      Fetchers::LastfmParser.parse(lastfm_tracks)
    end
  end
end
