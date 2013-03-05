# TODO:
#   This is where the various fields are in the JSON data
#   returned from the API
#
# name
# artist.content => artist_name
# album.content => album_name
# url
# image.small => small_image
# image.medium => medium_image
# image.large => large_image
# date.uts => played_timestamp
# date.content => played_datetime

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

        def thumbnail(size)
          thumbnail = thumbnails.where(size: size).first
          thumbnail.url unless thumbnail.nil?
        end

        def self.latest_timestamp
          max(:event_timestamp)
        end
      end
    end
  end
end
