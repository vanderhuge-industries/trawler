module Trawler
  module Stores
    module Pinboard
      class Bookmark
        include Mongoid::Document

        [:url, :title, :description, :tags].each do |f|
          field f, type: String
        end

        field :time, type: DateTime
      end
    end
  end
end

