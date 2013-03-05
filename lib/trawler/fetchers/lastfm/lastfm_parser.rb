module Trawler
  module Fetchers
    # TODO: Map these to a local model?
    # - it would be more resilient to API changes and be a nice
    #   entry point for persistence.

    class LastfmParser
      def self.parse(tracks)
        tracks.each do |track|
          Trawler::Stores::Lastfm::Track.create(event_timestamp: track["date"]["uts"])
        end
      end
    end
  end
end
