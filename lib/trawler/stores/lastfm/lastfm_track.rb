module Trawler
  module Stores
    module Lastfm
      class Track
        include Mongoid::Document

        field :event_timestamp, type: Integer

        [:name, :artist_name, :album_name, :url].each do |f|
          field f, type: String
        end

        field :played_datetime, type: DateTime

        embeds_many :thumbnails
        accepts_nested_attributes_for :thumbnails

        def thumbnail(size)
          thumbnail = thumbnails.where(size: size).first
          thumbnail.url unless thumbnail.nil?
        end

        def self.latest_timestamp
          max(:event_timestamp)
        end
      end

      class Thumbnail
        include Mongoid::Document

        field :size, type: String
        field :url, type: String
        embedded_in :track
      end
    end
  end
end
