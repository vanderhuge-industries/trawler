module Trawler
  module Fetchers
    class LastfmParser
      # TODO:
      # Handle "nowplaying: true" track which has no date data but is currently playing.
      def self.parse(tracks)
        tracks.map do |track|
          Trawler::Stores::Lastfm::Track.create(
            event_timestamp:  track['date']['uts'],
            played_datetime:  DateTime.parse(track['date']['content']),
            name:             track['name'],
            artist_name:      track['artist']['content'],
            album_name:       track['album']['content'],
            url:              track['url'],

            thumbnails_attributes: (parse_thumbnails(track['image']) unless track['image'].nil?)
          )
        end
      end

      def self.parse_thumbnails(images)
        images.map { |image| { size: image['size'], url: image['content'] } }
      end
    end
  end
end
