module Trawler
  module Stores
    class Bookmark
      include Mongoid::Document

      [:url, :title, :description, :tags].each do |f|
        field f, type: String
      end

      field :source, type: Symbol

      field :time, type: DateTime
    end
  end
end

