module Trawler
  module Stores
    module Lastfm
      class Thumbnail
        include Mongoid::Document

        field :size, type: String
        field :url, type: String
        embedded_in :track
      end
    end
  end
end
